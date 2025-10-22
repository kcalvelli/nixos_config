# Disko Module

This module provides declarative disk configuration templates using [disko](https://github.com/nix-community/disko) for automated disk partitioning and formatting.

## Overview

Disko enables fully declarative disk management, allowing you to define partitions, filesystems, encryption, and mount options in Nix configuration. This eliminates manual partitioning and makes host provisioning reproducible.

## Available Templates

### `standard-ext4.nix`
**Use case:** Desktop workstations, servers, systems without encryption requirements

**Features:**
- GPT partition table
- 1GB ESP boot partition
- Dedicated swap partition (configurable size)
- Ext4 root partition
- Performance optimizations: noatime, nodiratime, discard

**Parameters:**
- `device` - Target disk (default: `/dev/sda`)
- `swapSize` - Swap partition size (default: `"8G"`)

**Example:**
```nix
{
  imports = [ ../../modules/disko/templates/standard-ext4.nix ];
  
  disko.devices.disk.main.device = "/dev/nvme0n1";
  disko.devices.disk.main.content.partitions.swap.size = "16G";
}
```

### `luks-ext4.nix`
**Use case:** Laptops, portable systems, security-sensitive deployments

**Features:**
- GPT partition table
- 1GB ESP boot partition (unencrypted)
- LUKS-encrypted root partition
- Ext4 filesystem inside LUKS
- Swapfile on encrypted root
- Discard support for SSDs

**Parameters:**
- `device` - Target disk (default: `/dev/sda`)
- `swapSize` - Swapfile size (default: `"8G"`)

**Example:**
```nix
{
  imports = [ ../../modules/disko/templates/luks-ext4.nix ];
  
  disko.devices.disk.main.device = "/dev/nvme0n1";
  swapDevices = [{
    device = "/swapfile";
    size = 16000;  # 16GB
  }];
}
```

### `btrfs-subvolumes.nix`
**Use case:** Advanced users, systems requiring snapshots, compression benefits

**Features:**
- GPT partition table
- 1GB ESP boot partition
- Btrfs filesystem with subvolumes
- Subvolumes: `@` (root), `@home`, `@nix`, `@snapshots`
- Built-in compression (zstd by default)
- Dedicated swap partition
- Optimizations: space_cache=v2, discard=async

**Parameters:**
- `device` - Target disk (default: `/dev/sda`)
- `swapSize` - Swap partition size (default: `"8G"`)
- `compression` - Compression algorithm (default: `"zstd"`)

**Example:**
```nix
{
  imports = [ ../../modules/disko/templates/btrfs-subvolumes.nix ];
  
  disko.devices.disk.main.device = "/dev/nvme0n1";
  disko.devices.disk.main.content.partitions.swap.size = "16G";
  disko.devices.disk.main.content.partitions.root.content.extraArgs = [ "-f" "--features" "zstd" ];
}
```

## Installation Workflow

### New Host Installation

1. **Boot NixOS installer ISO**

2. **Clone your configuration:**
   ```bash
   git clone https://github.com/yourusername/nixos_config
   cd nixos_config
   ```

3. **Create host configuration:**
   ```bash
   mkdir -p hosts/newhostname
   ```

4. **Create `hosts/newhostname/disko.nix`:**
   ```nix
   { ... }:
   {
     imports = [ ../../modules/disko/templates/standard-ext4.nix ];
     
     # Customize for your hardware
     disko.devices.disk.main.device = "/dev/nvme0n1";
   }
   ```

5. **Create `hosts/newhostname/default.nix`:**
   ```nix
   { nixosModules, homeModules, ... }:
   {
     imports = [ ./disko.nix ]
       ++ (with nixosModules; [
         system
         desktop
         # ... other modules
       ]);
     
     networking.hostName = "newhostname";
     home-manager.sharedModules = with homeModules; [ workstation ];
   }
   ```

6. **Add to `hosts/default.nix`:**
   ```nix
   newhostname = nixosSystem {
     system = "x86_64-linux";
     modules = [
       inputs.disko.nixosModules.disko
       # ... other common modules
       ./newhostname
     ];
   };
   ```

7. **Partition and format the disk:**
   ```bash
   sudo nix run github:nix-community/disko -- \
     --mode disko \
     ./hosts/newhostname/disko.nix
   ```

8. **Install NixOS:**
   ```bash
   sudo nixos-install --flake .#newhostname
   ```

9. **Reboot:**
   ```bash
   reboot
   ```

### Updating Existing Hosts

For hosts already running, the disko configuration serves as documentation and disaster recovery blueprint. The configuration will be used if you ever need to reinstall the system from scratch.

## Template Selection Guide

| Requirement | Recommended Template |
|-------------|---------------------|
| Desktop workstation | `standard-ext4.nix` |
| Server | `standard-ext4.nix` |
| Laptop | `luks-ext4.nix` |
| Portable device | `luks-ext4.nix` |
| Need encryption | `luks-ext4.nix` |
| Want snapshots | `btrfs-subvolumes.nix` |
| Large datasets | `btrfs-subvolumes.nix` |
| Compression benefits | `btrfs-subvolumes.nix` |

## Customization Examples

### Different Swap Size
```nix
# For 16GB swap
disko.devices.disk.main.content.partitions.swap.size = "16G";
```

### Multiple Disks
```nix
{
  disko.devices.disk = {
    primary = {
      device = "/dev/nvme0n1";
      # ... config
    };
    secondary = {
      device = "/dev/nvme1n1";
      # ... config
    };
  };
}
```

### Custom Mount Options
```nix
disko.devices.disk.main.content.partitions.root.content.mountOptions = [
  "noatime"
  "nodiratime"
  "discard"
  "errors=remount-ro"
];
```

## Disaster Recovery

If you need to reinstall a system:

1. Boot installer ISO
2. Clone configuration
3. Run disko with the host's disko.nix:
   ```bash
   sudo nix run github:nix-community/disko -- --mode disko ./hosts/hostname/disko.nix
   ```
4. Reinstall:
   ```bash
   sudo nixos-install --flake .#hostname
   ```

Your disk layout will be identical to the original installation.

## Troubleshooting

### "Device busy" errors
Unmount any existing partitions:
```bash
sudo umount -R /mnt
sudo swapoff -a
```

### Inspect disko config without applying
```bash
nix run github:nix-community/disko -- --mode mount ./hosts/hostname/disko.nix
```

### View what disko will do
```bash
nix run github:nix-community/disko -- --mode dry-run ./hosts/hostname/disko.nix
```

## References

- [Disko GitHub](https://github.com/nix-community/disko)
- [Disko Documentation](https://github.com/nix-community/disko/tree/master/docs)
- [Disko Examples](https://github.com/nix-community/disko/tree/master/example)
