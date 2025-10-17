# Building Notes

## Current Build Status

The ISO build is in progress. Here are some notes:

### Fixed Issues

1. **ZFS Kernel Compatibility** 
   - Issue: ZFS kernel module 2.3.4 is broken with latest kernel 6.17.3
   - Fix: Disabled ZFS in installer ISO (not needed for installation)
   - Location: `hosts/installer/default.nix`
   ```nix
   boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
   ```

### Build Process

The ISO build will:
1. Download ~212 packages (~41MB)
2. Build ~44 derivations
3. Create the ISO image
4. Total time: 10-30 minutes (depending on internet speed)

### Warnings (Non-critical)

- `isoImage.isoName` has been renamed to `image.fileName` in newer NixOS
  - This is just a deprecation warning
  - ISO will still build correctly
  - Can be updated later if desired

### Build Command

```bash
nix build .#iso
```

### Output

After successful build:
```
result/iso/axios-installer-x86_64-linux.iso
```

### Next Steps

Once build completes:

1. **Verify the ISO exists:**
   ```bash
   ls -lh result/iso/*.iso
   ```

2. **Test in VM:**
   ```bash
   nix run nixpkgs#qemu -- -cdrom result/iso/*.iso -m 4096 -enable-kvm
   ```

3. **Create bootable USB:**
   ```bash
   sudo dd if=result/iso/*.iso of=/dev/sdX bs=4M status=progress conv=fsync
   ```

## Customization Options

### Use Stable Kernel Instead

If you prefer a stable kernel over latest:

```nix
# In hosts/installer/default.nix
boot.kernelPackages = pkgs.linuxPackages;  # Instead of linuxPackages_latest
```

This avoids ZFS compatibility issues but may have less hardware support.

### Re-enable ZFS

If you need ZFS support in the installer:

```nix
# Remove the supportedFilesystems override
# boot.supportedFilesystems = lib.mkForce [ ... ];

# Use stable kernel
boot.kernelPackages = pkgs.linuxPackages;
```

### Update isoImage.isoName

To fix the deprecation warning:

```nix
# In hosts/installer/default.nix
# Replace:
isoImage.isoName = ...

# With:
image.fileName = ...
```

## Troubleshooting

### Build fails with disk space error
```bash
# Clean up old builds
nix-collect-garbage -d

# Check free space
df -h /nix
```

### Build takes too long
- Normal for first build
- Subsequent builds use cache
- Consider using binary cache: `cachix use nixos`

### ISO won't boot
- Check UEFI vs BIOS mode
- Disable Secure Boot
- Verify USB was written correctly

## Build Artifacts

After build completes, you'll have:

```
result/
└── iso/
    └── axios-installer-x86_64-linux.iso  (~1GB)
```

The `result` symlink points to the Nix store path containing the ISO.
