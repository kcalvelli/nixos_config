# Building the axiOS Installer ISO

This guide explains how to build a custom axiOS installer ISO that includes the automated installation script.

## Quick Start

### Build the ISO

```bash
# From the repository root
nix build .#iso

# The ISO will be created at:
# result/iso/axios-installer-x86_64-linux.iso
```

### Write to USB Drive

```bash
# Find your USB device
lsblk

# Write the ISO (replace /dev/sdX with your USB device)
sudo dd if=result/iso/axios-installer-x86_64-linux.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

### Boot and Install

1. **Disable Secure Boot** in BIOS/UEFI (required - the ISO cannot boot with Secure Boot enabled)
2. Boot from the USB drive
3. Wait for the welcome message
4. For WiFi: Run `nmtui` to configure network
5. Run `install` to start the automated installer
6. Follow the prompts

**Note:** The installed system uses systemd-boot by default. Secure Boot support via Lanzaboote is available but disabled by default. After installation, you can optionally enable Secure Boot by following the steps in the [Post-Installation](#post-installation) section of the installation guide.

## ISO Contents

The custom axiOS installer ISO includes:

- **Base NixOS installer** with minimal packages
- **NetworkManager** for easy WiFi setup
- **Automated installer script** (`/root/install`)
- **Pre-cloned axiOS config** (auto-downloaded on boot if network available)
- **Disk management tools** (gparted, parted, testdisk)
- **Development tools** (git, vim, neovim, tmux)
- **System utilities** (htop, btop, ripgrep, etc.)

## Build Options

### Minimal ISO (Default)

The default build creates a minimal text-mode installer:

```nix
# In hosts/installer/default.nix
imports = [
  "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
];
```

Size: ~1GB

### Graphical ISO

For a GUI installer with GNOME:

```nix
# In hosts/installer/default.nix
imports = [
  "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
];
```

Size: ~2-3GB

### Custom Branding

Add custom splash screen:

```nix
# In hosts/installer/default.nix
isoImage = {
  splashImage = ../../docs/logo.png;
  # ... other options
};
```

## Testing the ISO

### Test in QEMU (No Installation)

```bash
# Quick boot test
nix run nixpkgs#qemu -- \
  -cdrom result/iso/axios-installer-x86_64-linux.iso \
  -m 4096 \
  -enable-kvm

# With UEFI support
nix run nixpkgs#qemu -- \
  -cdrom result/iso/axios-installer-x86_64-linux.iso \
  -m 4096 \
  -enable-kvm \
  -bios ${pkgs.OVMF.fd}/FV/OVMF.fd
```

### Test Full Installation in VM

```bash
# Create a test disk
qemu-img create -f qcow2 test-disk.qcow2 50G

# Boot from ISO with test disk (using virtio for better compatibility)
nix run nixpkgs#qemu -- \
  -cdrom result/iso/axios-installer-x86_64-linux.iso \
  -drive file=test-disk.qcow2,format=qcow2,if=virtio \
  -m 4096 \
  -enable-kvm \
  -cpu host \
  -smp 4

# After installation, boot from disk:
nix run nixpkgs#qemu -- \
  -drive file=test-disk.qcow2,format=qcow2,if=virtio \
  -m 4096 \
  -enable-kvm \
  -cpu host \
  -smp 4
```

## Build Configuration

### Customize Packages

Add packages to the installer environment:

```nix
# In hosts/installer/default.nix
environment.systemPackages = with pkgs; [
  # Your additional tools
  firefox  # Add browser to installer
  # ...
];
```

### Enable Services

```nix
# In hosts/installer/default.nix
services.openssh = {
  enable = true;
  # Allow remote installation assistance
};
```

## CI/CD Integration

### GitHub Actions

The ISO can be built automatically on GitHub:

```yaml
# .github/workflows/build-iso.yml
name: Build ISO

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:

jobs:
  build-iso:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: DeterminateSystems/nix-installer-action@main
        with:
          determinate: true
          
      - uses: DeterminateSystems/magic-nix-cache-action@main
      
      - name: Build ISO
        run: nix build .#iso -L
      
      - name: Upload ISO
        uses: actions/upload-artifact@v4
        with:
          name: axios-installer-iso
          path: result/iso/*.iso
          
      - name: Create Release
        if: startsWith(github.ref, 'refs/tags/')
        uses: softprops/action-gh-release@v1
        with:
          files: result/iso/*.iso
```

## Troubleshooting

### Build Fails with "out of disk space"

The ISO build requires significant disk space (~10GB free). Either:
- Free up disk space
- Use `nix-collect-garbage -d` to clean old builds
- Build on a machine with more storage

### ISO is Too Large

Reduce size by:
- Using minimal instead of graphical base
- Removing unnecessary packages from `environment.systemPackages`
- Increasing compression level in `isoImage.squashfsCompression`

### ISO Won't Boot

Check:
- UEFI vs Legacy BIOS settings in BIOS
- Secure Boot is disabled
- USB drive is set as first boot device
- ISO was written correctly (verify checksum)

### Network Not Working in Installer

The installer uses NetworkManager:
- For WiFi: Run `nmtui` and configure connection
- For wired: Should work automatically via DHCP
- Check cable/WiFi adapter is recognized: `ip link`

### Installer Script Not Found

If `/root/install` is missing:
- Check network connectivity: `ping 1.1.1.1`
- Manually clone: `git clone https://github.com/kcalvelli/nixos_config`
- Run script directly: `./nixos_config/scripts/shell/install-axios.sh`

## Advanced Usage

### Offline Installation

To use the installer without internet:

1. Pre-download the repository
2. Create a custom ISO that includes it:

```nix
# In hosts/installer/default.nix
systemd.services.clone-axios = lib.mkForce {
  # Disable auto-clone
  enable = false;
};

# Include repo in ISO
environment.etc."nixos_config".source = ../..;
```

### Custom Repository URL

To use your own fork:

```bash
# Edit scripts/shell/install-axios.sh
AXIOS_REPO="https://github.com/YOURUSERNAME/nixos_config"
```

Then rebuild the ISO.

### Multiple Configurations

Build different ISOs for different use cases:

```nix
# In flake.nix
packages = {
  iso-minimal = self.nixosConfigurations.installer-minimal.config.system.build.isoImage;
  iso-graphical = self.nixosConfigurations.installer-graphical.config.system.build.isoImage;
  iso-offline = self.nixosConfigurations.installer-offline.config.system.build.isoImage;
};
```

## Distribution

### Checksums

Generate checksums for verification:

```bash
# SHA256
sha256sum result/iso/*.iso > SHA256SUMS

# Or use nix
nix hash file result/iso/*.iso
```

### Release Process

1. Tag release: `git tag -a v1.0.0 -m "Release v1.0.0"`
2. Push tag: `git push origin v1.0.0`
3. GitHub Actions builds ISO automatically
4. Download from Actions artifacts
5. Create GitHub Release with ISO attached

### Hosting

Options for distributing the ISO:

- **GitHub Releases** - Free, built-in, recommended
- **Self-hosted** - Use a web server
- **Torrent** - For popular distributions
- **NixOS cache** - Share via Cachix or similar

## Maintenance

### Update Base System

The installer uses `nixpkgs-unstable` from your flake inputs.

To update:

```bash
nix flake update
git commit -am "Update flake inputs"
```

### Test After Updates

Always test the ISO after updating nixpkgs:

```bash
nix build .#iso
# Test in VM
```

## See Also

- [Installation Guide](INSTALLATION.md) - Using the installer
- [Installer Script](../scripts/shell/install-axios.sh) - Script source
- [ISO Configuration](../hosts/installer/default.nix) - ISO definition
- [NixOS ISO Building](https://nixos.wiki/wiki/Creating_a_NixOS_live_CD) - Upstream docs
