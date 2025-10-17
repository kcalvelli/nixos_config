# Btrfs Snapshots Implementation Guide

**Recommended Alternative to Impermanence**

This guide shows how to implement btrfs with automatic snapshots for rollback capability without the complexity of impermanence.

---

## Why Btrfs Snapshots Instead of Impermanence?

✅ **Pros**:
- Keep all state automatically (no persistence declarations)
- Atomic snapshots before system changes
- Easy rollback via boot menu
- Much simpler than impermanence
- Fast snapshot creation (<1 second)
- No secrets management complexity
- Works with existing apps and services

❌ **Cons** (compared to impermanence):
- Doesn't clean up system state automatically
- Still accumulates cruft over time (but snapshots make rollback easy)
- Slightly more disk space usage

---

## Overview

### What We'll Set Up

1. **Btrfs filesystem** with subvolumes
2. **Automatic snapshots** before system updates
3. **Bootloader integration** for easy rollback
4. **Optional: Snapshot cleanup** for disk space management

### Subvolume Layout

```
/dev/sda3 (btrfs)
├─ @          → /              (system root, frequent snapshots)
├─ @home      → /home          (user data, separate snapshots)
├─ @nix       → /nix           (Nix store, rarely snapshot)
└─ @snapshots → /.snapshots    (snapshot storage)
```

---

## Phase 1: Planning and Backup

### 1.1 Check Current Disk Layout

```bash
# Check current partitions
lsblk -f

# Check disk usage
df -h

# Check what's using space
sudo du -sh /* | sort -h
```

### 1.2 Create Backups

**Critical**: Backup everything before proceeding!

```bash
# User data
tar -czf ~/backup-home-$(date +%Y%m%d).tar.gz ~/{Documents,Pictures,Projects,Downloads}

# System config (already in git, but just in case)
sudo tar -czf /root/backup-etc-$(date +%Y%m%d).tar.gz /etc/nixos

# Service state (if any critical services)
sudo tar -czf /root/backup-var-lib-$(date +%Y%m%d).tar.gz /var/lib/{home-assistant,mosquitto,ollama} 2>/dev/null

# Copy backups to external drive or cloud
rsync -av --progress ~/*.tar.gz /mnt/backup/  # Adjust path
```

### 1.3 Test in VM First (Recommended)

1. Create a VM with same config
2. Practice the migration
3. Verify snapshot and rollback work
4. Only then proceed on real hardware

---

## Phase 2: Create Btrfs Disko Configuration

### 2.1 Create Host-Specific Disko Config

For **edge** (example with 16GB swap):

```nix
# hosts/edge/disko/btrfs.nix
{ device ? "/dev/sda", swapSize ? "16G", ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = device;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };
            swap = {
              priority = 2;
              size = swapSize;
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              priority = 3;
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [ 
                      "compress=zstd"
                      "noatime" 
                      "space_cache=v2" 
                      "discard=async"
                    ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ 
                      "compress=zstd" 
                      "noatime" 
                      "space_cache=v2" 
                      "discard=async"
                    ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ 
                      "compress=zstd" 
                      "noatime" 
                      "space_cache=v2" 
                      "discard=async"
                    ];
                  };
                  "@snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [ 
                      "compress=zstd" 
                      "noatime" 
                      "space_cache=v2" 
                      "discard=async"
                    ];
                  };
                  "@var-log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ 
                      "compress=zstd" 
                      "noatime" 
                      "space_cache=v2" 
                      "discard=async"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
```

For **pangolin** (LUKS encrypted):

```nix
# hosts/pangolin/disko/btrfs-luks.nix
{ device ? "/dev/sda", swapSize ? "8G", ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = device;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            luks = {
              priority = 2;
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                passwordFile = "/tmp/secret.key"; # Set during install
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" "space_cache=v2" ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" "space_cache=v2" ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" "space_cache=v2" ];
                    };
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = [ "compress=zstd" "noatime" "space_cache=v2" ];
                    };
                    "@swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = swapSize;
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
```

### 2.2 Update Host Configuration

Update `hosts/edge.nix`:

```nix
# Change diskConfigPath to new btrfs config
diskConfigPath = ./edge/disko/btrfs.nix;
```

Update `hosts/pangolin.nix`:

```nix
diskConfigPath = ./pangolin/disko/btrfs-luks.nix;
```

---

## Phase 3: Migration Process

### 3.1 Boot from NixOS Live USB

1. Download NixOS ISO
2. Create bootable USB
3. Boot from USB

### 3.2 Apply Disko Configuration

```bash
# On live USB, clone your config
git clone https://github.com/kcalvelli/nixos_config
cd nixos_config

# CRITICAL: Verify the device path
lsblk  # Make sure you're targeting correct disk!

# For edge (unencrypted)
sudo nix run github:nix-community/disko -- \
  --mode disko \
  --arg device '"/dev/sda"' \
  hosts/edge/disko/btrfs.nix

# For pangolin (encrypted)
# Create temporary password file
echo "your-disk-encryption-password" | sudo tee /tmp/secret.key
sudo nix run github:nix-community/disko -- \
  --mode disko \
  --arg device '"/dev/sda"' \
  hosts/pangolin/disko/btrfs-luks.nix
sudo rm /tmp/secret.key  # Clean up
```

### 3.3 Mount and Restore Data

```bash
# Filesystems are already mounted by disko at /mnt

# Restore user data
sudo mkdir -p /mnt/home/keith
sudo tar -xzf /path/to/backup-home-*.tar.gz -C /mnt/home/keith

# Restore service state (if needed)
sudo tar -xzf /path/to/backup-var-lib-*.tar.gz -C /mnt

# Set ownership
sudo chown -R 1000:1000 /mnt/home/keith  # Adjust UID if different
```

### 3.4 Install NixOS

```bash
# Generate hardware config
sudo nixos-generate-config --root /mnt

# Copy your flake
sudo cp -r ~/nixos_config /mnt/etc/nixos/

# Install
cd /mnt/etc/nixos
sudo nixos-install --flake .#edge  # or .#pangolin
```

### 3.5 Reboot and Verify

```bash
sudo reboot
```

After reboot:
```bash
# Verify btrfs layout
sudo btrfs subvolume list /

# Check mounts
mount | grep btrfs

# Verify services work
systemctl status home-assistant  # if applicable
```

---

## Phase 4: Configure Snapper for Automatic Snapshots

### 4.1 Create Snapper Module

```nix
# modules/system/snapper.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.system.snapper;
in
{
  options.system.snapper = {
    enable = lib.mkEnableOption "Snapper automatic snapshots";
  };

  config = lib.mkIf cfg.enable {
    services.snapper = {
      configs = {
        root = {
          SUBVOLUME = "/";
          ALLOW_USERS = [ "keith" ];
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          
          # Keep snapshots for
          TIMELINE_LIMIT_HOURLY = "5";
          TIMELINE_LIMIT_DAILY = "7";
          TIMELINE_LIMIT_WEEKLY = "4";
          TIMELINE_LIMIT_MONTHLY = "3";
          TIMELINE_LIMIT_YEARLY = "0";
        };
        
        home = {
          SUBVOLUME = "/home";
          ALLOW_USERS = [ "keith" ];
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          
          # Keep more home snapshots
          TIMELINE_LIMIT_HOURLY = "10";
          TIMELINE_LIMIT_DAILY = "14";
          TIMELINE_LIMIT_WEEKLY = "8";
          TIMELINE_LIMIT_MONTHLY = "6";
          TIMELINE_LIMIT_YEARLY = "2";
        };
      };
    };

    # Snapshot before system updates
    system.activationScripts.snapperPreActivation = ''
      if command -v snapper > /dev/null; then
        echo "Creating pre-activation snapshot..."
        ${pkgs.snapper}/bin/snapper -c root create -d "pre-activation-$(date +%Y%m%d-%H%M%S)" || true
      fi
    '';

    # Allow users to browse snapshots
    users.users.keith.extraGroups = [ "wheel" ];
    
    environment.systemPackages = with pkgs; [
      snapper
      btrfs-progs
    ];
  };
}
```

### 4.2 Enable Snapper

Add to `modules/system/default.nix`:

```nix
imports = [
  ./snapper.nix
  # ... other imports
];
```

Enable in host config (`hosts/edge.nix`):

```nix
extraConfig = {
  system.snapper.enable = true;
  # ... other config
};
```

---

## Phase 5: Bootloader Integration for Rollback

### 5.1 Install Grub-Btrfs

```nix
# In modules/system/boot.nix or similar
{ config, lib, pkgs, ... }:
{
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;  # For dual-boot
    
    # Add snapshots to boot menu
    extraEntries = ''
      # Placeholder - grub-btrfs will populate
    '';
  };

  # Install grub-btrfs for snapshot boot entries
  environment.systemPackages = with pkgs; [
    grub2_efi
    btrfs-progs
  ];

  # Regenerate grub config after snapshots
  systemd.services.grub-btrfs = {
    description = "Update GRUB to include Btrfs snapshots";
    after = [ "snapper-timeline.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.grub2_efi}/bin/grub-mkconfig -o /boot/grub/grub.cfg'";
    };
  };

  systemd.paths.grub-btrfs = {
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathModified = "/.snapshots";
    };
  };
}
```

### 5.2 Test Rollback

After setup:

1. Check snapshots: `sudo snapper list`
2. Make a test change: `sudo touch /test-file`
3. Create snapshot: `sudo snapper -c root create -d "test"`
4. Reboot and select snapshot from GRUB menu
5. Verify file is gone
6. To make snapshot permanent: `sudo btrfs subvolume set-default`

---

## Phase 6: Maintenance and Monitoring

### 6.1 Regular Snapshot Management

```bash
# List all snapshots
sudo snapper list

# Compare snapshots
sudo snapper diff 1..2

# Delete old snapshot
sudo snapper delete 5

# Rollback to snapshot (non-destructive)
sudo snapper -c root rollback 10
```

### 6.2 Disk Space Monitoring

```bash
# Check btrfs usage
sudo btrfs filesystem usage /

# Check subvolume sizes
sudo btrfs filesystem du -s /@*

# Check snapshot sizes
sudo btrfs filesystem du -s /.snapshots/*
```

### 6.3 Automated Cleanup Script

```nix
# Add to system configuration
systemd.timers.snapshot-cleanup = {
  wantedBy = [ "timers.target" ];
  timerConfig = {
    OnCalendar = "weekly";
    Persistent = true;
  };
};

systemd.services.snapshot-cleanup = {
  serviceConfig = {
    Type = "oneshot";
    ExecStart = pkgs.writeScript "snapshot-cleanup" ''
      #!${pkgs.bash}/bin/bash
      # Remove snapshots older than 2 months
      ${pkgs.snapper}/bin/snapper -c root cleanup timeline
      ${pkgs.snapper}/bin/snapper -c home cleanup timeline
      
      # Log cleanup
      echo "$(date): Snapshot cleanup completed" >> /var/log/snapshot-cleanup.log
    '';
  };
};
```

---

## Common Tasks

### Snapshot Before Major Changes

```bash
# Before system update
sudo snapper -c root create -d "before-nixos-rebuild-$(date +%Y%m%d)"

# Rebuild
sudo nixos-rebuild switch --flake .#edge

# If something breaks, rollback from GRUB menu on next boot
```

### View Files in Snapshot

```bash
# Snapshots are in /.snapshots
ls -la /.snapshots/

# Each snapshot has a /snapshot subdirectory
ls -la /.snapshots/5/snapshot/

# Compare file between snapshot and current
diff /.snapshots/5/snapshot/etc/some-file /etc/some-file
```

### Restore Single File

```bash
# Copy file from snapshot
sudo cp /.snapshots/5/snapshot/path/to/file /path/to/file
```

### Full System Rollback

1. Boot to GRUB menu
2. Select snapshot entry
3. Boot into snapshot
4. To make permanent: `sudo btrfs subvolume set-default <snapshot-id> /`

---

## Comparison: Before and After

### Before (ext4)

```
✗ No easy rollback
✗ Manual backups needed
✗ Full reinstall if corrupted
✗ No atomic updates
✓ Simple filesystem
✓ Well understood
```

### After (btrfs + snapshots)

```
✓ Instant rollback via boot menu
✓ Automatic snapshots before updates
✓ Can recover from corruption
✓ Atomic snapshot creation
✓ CoW (Copy on Write) = efficient
✓ Compression saves disk space
✗ Slightly more complex
✗ Need to monitor disk space
```

---

## Troubleshooting

### Snapshot Creation Fails

```bash
# Check disk space
df -h
sudo btrfs filesystem usage /

# Clean up old snapshots
sudo snapper delete <snapshot-number>
```

### Boot from Snapshot Fails

```bash
# Boot from live USB
sudo mount /dev/sda3 /mnt -o subvol=@

# Check what went wrong
journalctl --directory=/mnt/var/log/journal

# Fix and reboot
```

### Disk Full Despite Free Space

Btrfs can show as full even with free space due to metadata:

```bash
# Balance filesystem
sudo btrfs balance start -dusage=50 /

# This can take time, run in background
sudo btrfs balance start -dusage=50 -musage=50 / &
```

---

## Benefits Over Impermanence

| Feature | Btrfs Snapshots | Impermanence |
|---------|----------------|--------------|
| Easy rollback | ✅ Yes | ✅ Yes |
| Keeps all state | ✅ Yes | ❌ Need declarations |
| Boot time | ✅ Fast | ⚠️ Slower (regeneration) |
| Complexity | ✅ Low | ❌ High |
| Secrets handling | ✅ No change | ❌ Need agenix/sops |
| Data loss risk | ✅ Low | ⚠️ Higher |
| External scripts | ✅ No change | ❌ Need flake-ify |
| Service state | ✅ Automatic | ❌ Manual persistence |

---

## Estimated Timeline

- **Backup**: 1-2 hours
- **Disko config creation**: 1 hour
- **Migration (per host)**: 2-3 hours
- **Snapper setup**: 1-2 hours
- **Testing**: 2-3 hours
- **Documentation**: 1 hour

**Total**: 8-12 hours per host

---

## Next Steps

1. ✅ Read this guide fully
2. ✅ Backup everything (multiple copies!)
3. ✅ Test in VM first
4. ✅ Create disko configs
5. ✅ Migrate one host (test host if available)
6. ✅ Verify everything works
7. ✅ Migrate other hosts
8. ✅ Set up snapper
9. ✅ Test rollback procedure
10. ✅ Document your specific setup

---

## Additional Resources

- [NixOS Btrfs Wiki](https://wiki.nixos.org/wiki/Btrfs)
- [Snapper Documentation](http://snapper.io/documentation.html)
- [Disko Documentation](https://github.com/nix-community/disko)
- [Btrfs Best Practices](https://btrfs.wiki.kernel.org/index.php/SysadminGuide)

---

## Conclusion

Btrfs with snapshots gives you **most of the benefits of impermanence** (easy rollback, atomic updates) without the complexity of managing persistence declarations, secrets, and external dependencies.

For your setup with stateful services, external scripts, and home-manager gaps, this is the **much safer and more practical choice**.
