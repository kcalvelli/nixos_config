# axiOS Installer - Quick Reference

## For Users

### Download & Install

```bash
# 1. Download latest ISO
wget https://github.com/kcalvelli/nixos_config/releases/latest/download/axios-installer-x86_64-linux.iso

# 2. Write to USB
sudo dd if=axios-installer-x86_64-linux.iso of=/dev/sdX bs=4M status=progress conv=fsync

# 3. Boot from USB

# 4. Configure WiFi (if needed)
nmtui

# 5. Run installer
/root/install

# 6. Follow prompts and wait for installation
```

See [INSTALLATION.md](INSTALLATION.md) for detailed guide.

## For Developers

### Build ISO Locally

```bash
# Build the ISO
nix build .#iso

# Output location
ls -lh result/iso/*.iso

# Test in QEMU
nix run nixpkgs#qemu -- -cdrom result/iso/*.iso -m 4096 -enable-kvm
```

### Customize Installer

**Modify installer script:**
```bash
vim scripts/shell/install-axios.sh
# Make changes, rebuild ISO
nix build .#iso
```

**Change ISO packages:**
```bash
vim hosts/installer/default.nix
# Add to environment.systemPackages
nix build .#iso
```

**Switch to graphical installer:**
```nix
# In hosts/installer/default.nix, change import to:
"${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
```

### Test Installation in VM

```bash
# Create test disk
qemu-img create -f qcow2 test-disk.qcow2 50G

# Boot from ISO with test disk (using virtio)
nix run nixpkgs#qemu -- \
  -cdrom result/iso/*.iso \
  -drive file=test-disk.qcow2,format=qcow2,if=virtio \
  -m 4096 \
  -enable-kvm \
  -cpu host \
  -smp 4

# After installation, boot from disk
nix run nixpkgs#qemu -- \
  -drive file=test-disk.qcow2,format=qcow2,if=virtio \
  -m 4096 \
  -enable-kvm \
  -cpu host \
  -smp 4
```

## File Structure

```
axiOS/
├── scripts/
│   └── install-axios.sh          # Automated installer script
├── hosts/
│   └── installer/
│       └── default.nix            # ISO configuration
├── docs/
│   ├── INSTALLATION.md           # User installation guide
│   ├── BUILDING_ISO.md           # Developer ISO build guide
│   └── QUICK_REFERENCE.md        # This file
└── .github/
    └── workflows/
        └── build-iso.yml         # CI/CD ISO build workflow
```

## Common Tasks

### Update Repository URL in Installer

```bash
# Edit scripts/shell/install-axios.sh
vim scripts/shell/install-axios.sh
# Change: AXIOS_REPO="https://github.com/YOURUSERNAME/nixos_config"
```

### Add Packages to Installer Environment

```nix
# In hosts/installer/default.nix
environment.systemPackages = with pkgs; [
  # Add your packages here
  firefox
  neofetch
];
```

### Create Release with ISO

```bash
# 1. Tag release
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# 2. GitHub Actions automatically builds ISO

# 3. Download from Actions artifacts or wait for release
```

### Manual Host Installation

If you prefer not to use the automated script:

```bash
# 1. Clone repo
git clone https://github.com/kcalvelli/nixos_config
cd nixos_config

# 2. Create host config
mkdir -p hosts/myhostname
cp hosts/TEMPLATE.nix hosts/myhostname.nix
vim hosts/myhostname.nix

# 3. Create disko config
cp modules/disko/templates/standard-ext4.nix hosts/myhostname/disko.nix
vim hosts/myhostname/disko.nix  # Set device = "/dev/nvme0n1"

# 4. Register host
vim hosts/default.nix
# Add: myhostname = mkSystem (import ./myhostname.nix { inherit lib; }).hostConfig;

# 5. Partition disk
sudo nix run github:nix-community/disko -- --mode disko hosts/myhostname/disko.nix

# 6. Install
mkdir -p /mnt/etc/nixos
cp -r ./* /mnt/etc/nixos/
sudo nixos-install --flake /mnt/etc/nixos#myhostname

# 7. Reboot
reboot
```

## Troubleshooting Quick Fixes

### Network not working
```bash
# Start NetworkManager
sudo systemctl start NetworkManager

# Configure WiFi
nmtui
```

### Installer script not found
```bash
# Manual clone
cd /root
git clone https://github.com/kcalvelli/nixos_config
./nixos_config/scripts/shell/install-axios.sh
```

### Disk already partitioned
```bash
# Unmount and retry
sudo umount -R /mnt
sudo swapoff -a
# Then retry disko
```

### Disk partitioning fails in VM
```bash
# Use virtio drives for better compatibility
nix run nixpkgs#qemu -- \
  -cdrom result/iso/*.iso \
  -drive file=test-disk.qcow2,format=qcow2,if=virtio \
  -m 4096 -enable-kvm -cpu host -smp 4
```

### Out of disk space during install
```bash
# Check space
df -h

# Clean up if needed
nix-collect-garbage -d
```

## Links

- **Installation Guide**: [INSTALLATION.md](INSTALLATION.md)
- **Build ISO Guide**: [BUILDING_ISO.md](BUILDING_ISO.md)
- **Repository**: https://github.com/kcalvelli/nixos_config
- **Releases**: https://github.com/kcalvelli/nixos_config/releases
- **Issues**: https://github.com/kcalvelli/nixos_config/issues
