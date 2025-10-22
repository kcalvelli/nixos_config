# Installing axiOS

This guide walks you through installing axiOS using the automated installer.

## Prerequisites

- axiOS installer ISO or standard NixOS installer
- Target machine with:
  - x86_64 CPU (AMD or Intel)
  - 4GB+ RAM (8GB+ recommended)
  - 20GB+ disk space (50GB+ recommended)
  - Internet connection (for downloading packages)

## Download

### Option 1: Use axiOS Custom ISO (Recommended)

Download the latest ISO from [GitHub Releases](https://github.com/kcalvelli/nixos_config/releases):

```bash
# Download latest release
wget https://github.com/kcalvelli/nixos_config/releases/latest/download/axios-installer-x86_64-linux.iso

# Verify checksum (optional but recommended)
sha256sum axios-installer-x86_64-linux.iso
```

### Option 2: Use Standard NixOS ISO

Download from [nixos.org](https://nixos.org/download):
- Minimal ISO: ~1GB, text-mode only
- Graphical ISO: ~3GB, includes GNOME desktop

## Create Bootable USB

### Linux

```bash
# Find your USB device
lsblk

# Write ISO to USB (replace /dev/sdX with your device)
sudo dd if=axios-installer-x86_64-linux.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

### macOS

```bash
# Find your USB device
diskutil list

# Unmount the disk (replace diskN with your device)
diskutil unmountDisk /dev/diskN

# Write ISO
sudo dd if=axios-installer-x86_64-linux.iso of=/dev/rdiskN bs=4m
```

### Windows

Use [Rufus](https://rufus.ie/) or [balenaEtcher](https://www.balena.io/etcher/):
1. Select the ISO file
2. Select your USB drive
3. Click "Flash" or "Start"

## Installing to a Virtual Machine

axiOS can be installed in a VM for testing or development. This is recommended before installing on bare metal.

### Quick VM Installation

For quick testing with QEMU (Linux/macOS):

```bash
# Download the ISO
wget https://github.com/kcalvelli/nixos_config/releases/latest/download/axios-installer-x86_64-linux.iso

# Create a virtual disk (30GB, adjust as needed)
qemu-img create -f qcow2 axios-vm.qcow2 30G

# Boot the VM
qemu-system-x86_64 \
  -cdrom axios-installer-x86_64-linux.iso \
  -drive file=axios-vm.qcow2,format=qcow2,if=virtio \
  -m 4096 \
  -enable-kvm \
  -cpu host \
  -smp 4 \
  -vga virtio \
  -display gtk,grab-on-hover=on \
  -net nic,model=virtio \
  -net user
```

After installation completes, boot from disk:

```bash
# Remove -cdrom line to boot from installed system
qemu-system-x86_64 \
  -drive file=axios-vm.qcow2,format=qcow2,if=virtio \
  -m 4096 \
  -enable-kvm \
  -cpu host \
  -smp 4 \
  -vga virtio \
  -display gtk,grab-on-hover=on \
  -net nic,model=virtio \
  -net user
```

### VMware Workstation / Fusion

1. **Create new VM**:
   - Select "Custom (advanced)"
   - Hardware compatibility: Latest
   - Install from: Installer disc image (iso)
   - Browse to `axios-installer-x86_64-linux.iso`
   - Guest OS: Linux → Other Linux 6.x kernel 64-bit

2. **VM Settings**:
   - Memory: 4GB minimum, 8GB recommended
   - Processors: 2-4 cores
   - Hard Disk: 30GB minimum, 50GB+ recommended
   - Network Adapter: NAT or Bridged
   - Display: Enable 3D graphics acceleration

3. **Boot and Install**:
   - Power on VM
   - Follow [Automated Installation](#method-1-automated-installation-recommended) steps
   - No WiFi configuration needed (wired network auto-configured)

4. **Post-Installation**:
   - Shut down VM after installation
   - Remove ISO from virtual CD drive
   - Restart VM

**VMware Guest Additions**: The open-vm-tools package is automatically included in the base system configuration.

### VirtualBox

1. **Create new VM**:
   - Click "New"
   - Name: axiOS
   - Type: Linux
   - Version: Other Linux (64-bit)
   - Memory: 4096 MB (4GB) minimum
   - Create virtual hard disk (VDI, dynamically allocated, 30GB+)

2. **Configure VM Settings**:
   - System → Processor: 2-4 CPUs
   - System → Enable EFI (special OSes only)
   - Display → Video Memory: 128MB
   - Display → Graphics Controller: VMSVGA or VBoxVGA
   - Storage → Controller: IDE → Add optical drive → Choose `axios-installer-x86_64-linux.iso`
   - Network → Adapter 1: NAT or Bridged

3. **Boot and Install**:
   - Start VM
   - Follow [Automated Installation](#method-1-automated-installation-recommended) steps
   - No WiFi configuration needed

4. **Post-Installation**:
   - Shut down VM
   - Settings → Storage → Remove ISO from optical drive
   - Start VM

**VirtualBox Guest Additions**: Install after first boot:

```bash
# Add to your user configuration
environment.systemPackages = [ pkgs.virtualbox-guest-additions ];

# Rebuild
sudo nixos-rebuild switch --flake /etc/nixos#HOSTNAME
```

### virt-manager / KVM (Linux)

1. **Install virt-manager** (if not already installed):
   ```bash
   # On NixOS
   nix-shell -p virt-manager
   
   # Or add to configuration.nix:
   # virtualisation.libvirtd.enable = true;
   # programs.virt-manager.enable = true;
   ```

2. **Create new VM**:
   - File → New Virtual Machine
   - Local install media (ISO)
   - Choose ISO: Browse to `axios-installer-x86_64-linux.iso`
   - OS type: Generic Linux 2022
   - Memory: 4096 MB
   - CPUs: 2-4 cores
   - Create disk: 30GB+
   - Customize before install: ✓

3. **Customize Hardware**:
   - Overview → Firmware: UEFI x86_64 (recommended)
   - Video: Virtio
   - Network: virtio
   - Disk Bus: VirtIO

4. **Install**:
   - Begin Installation
   - Follow [Automated Installation](#method-1-automated-installation-recommended) steps

5. **Post-Installation**:
   - Shut down VM
   - Remove CDROM or change boot order
   - Start VM

### UTM (macOS - Apple Silicon)

UTM provides excellent x86_64 emulation on Apple Silicon Macs:

1. **Create new VM**:
   - Create a New Virtual Machine
   - Emulate (for x86_64)
   - Linux
   - Browse for ISO: `axios-installer-x86_64-linux.iso`

2. **VM Settings**:
   - Architecture: x86_64
   - Memory: 4096 MB minimum
   - CPU cores: 2-4
   - Storage: 30GB+
   - Network: Shared Network

3. **Install**:
   - Start VM
   - Follow [Automated Installation](#method-1-automated-installation-recommended) steps
   - Note: Emulation is slower than native, installation may take 30-60 minutes

4. **Post-Installation**:
   - Shut down VM
   - Edit VM → CD/DVD → Clear
   - Start VM

**Performance Note**: x86_64 emulation on Apple Silicon is functional but slower than native. Consider using NixOS on a native x86_64 machine or wait for native ARM64 support.

### Hyper-V (Windows Pro/Enterprise)

1. **Enable Hyper-V**:
   - Control Panel → Programs → Turn Windows features on/off
   - Enable Hyper-V
   - Restart

2. **Create VM**:
   - Hyper-V Manager → Action → New → Virtual Machine
   - Name: axiOS
   - Generation: 2 (UEFI)
   - Memory: 4096 MB, enable Dynamic Memory
   - Networking: Default Switch
   - Virtual Hard Disk: 30GB+
   - Installation Options: Install from ISO → Browse to `axios-installer-x86_64-linux.iso`

3. **Configure Settings** (before first boot):
   - Security → Disable Secure Boot
   - Processor → 2-4 virtual processors

4. **Install**:
   - Start VM
   - Connect to VM
   - Follow [Automated Installation](#method-1-automated-installation-recommended) steps

5. **Post-Installation**:
   - Shut down VM
   - Settings → DVD Drive → Remove ISO
   - Start VM

### VM-Specific Considerations

**Network Configuration**:
- NAT networking works out of the box (no WiFi setup needed)
- For bridged networking, VM gets IP from your router
- Port forwarding may be needed for services

**Disk Performance**:
- Use virtio drivers when available (best performance)
- VirtualBox: Use VDI format
- VMware: Use VMDK format
- QEMU: Use qcow2 format

**Graphics**:
- Wayland works in VMs but may have reduced performance
- For testing, consider disabling desktop and using SSH
- Disable desktop module in host config for headless VMs

**Resource Allocation**:
- Minimum: 2 CPU cores, 4GB RAM, 20GB disk
- Recommended: 4 CPU cores, 8GB RAM, 50GB disk
- With desktop: +2GB RAM, +10GB disk
- With gaming: Not recommended in VMs

**Troubleshooting VMs**:

If installation fails with disk errors:
```bash
# Ensure using virtio drivers (QEMU/KVM)
# Avoid IDE/SATA emulation if possible
```

If VM won't boot after installation:
```bash
# Check boot order in VM settings
# Ensure ISO is removed from virtual CD drive
# Verify UEFI/BIOS mode matches installation
```

For slow VM performance:
```bash
# Enable hardware acceleration (KVM, Hyper-V, VMware)
# Increase RAM allocation
# Use virtio/paravirtualized drivers
# Reduce CPU core count if host has limited cores
```

## Boot from USB

1. Insert USB drive
2. Restart computer
3. **Disable Secure Boot** in BIOS/UEFI settings (required - see below)
4. Enter boot menu (usually F12, F2, ESC, or DEL during startup)
5. Select USB drive
6. Wait for installer to boot

### Secure Boot Notice

**The installer ISO cannot boot with Secure Boot enabled.** You must temporarily disable Secure Boot to boot the installer.

**Why?** NixOS installer ISOs use unsigned bootloaders. Only the installed system supports Secure Boot via Lanzaboote.

**Steps:**
1. Enter BIOS/UEFI settings (usually DEL, F2, or F12 during boot)
2. Navigate to Security → Secure Boot
3. Set Secure Boot to **Disabled**
4. Save and exit
5. Boot from the installer USB

**After installation:**
- Secure Boot is **disabled by default** for fresh installations
- The installed system uses systemd-boot initially
- You can optionally enable Secure Boot after first boot
- See the [First Boot](#first-boot) section below for Secure Boot setup instructions

## Installation Methods

### Method 1: Automated Installation (Recommended)

If using the axiOS custom ISO:

1. **Wait for boot** - The system will auto-login and display a welcome message

2. **Configure WiFi** (if needed):
   ```bash
   nmtui
   ```
   - Select "Activate a connection"
   - Choose your network
   - Enter password

3. **Run installer**:
   ```bash
   /root/install
   # or simply:
   install
   ```

4. **Follow prompts**:
   - Select hardware vendor (optional optimization)
   - Select disk
   - Choose layout (standard/encrypted/btrfs)
   - Set hostname
   - Create user account (username, full name, email)
   - Enable features (desktop/gaming/dev tools/etc.)
   - Confirm installation

5. **Wait for installation** (10-30 minutes)

6. **Set passwords** when prompted:
   - User password (your account)
   - Root password (system administrator)

7. **Reboot**:
   ```bash
   systemctl reboot
   ```

### Method 2: Manual Installation

If using standard NixOS ISO or want manual control:

1. **Configure network** (if using WiFi):
   ```bash
   sudo systemctl start wpa_supplicant
   wpa_cli
   > add_network
   > set_network 0 ssid "YourNetworkName"
   > set_network 0 psk "YourPassword"
   > enable_network 0
   > quit
   ```

2. **Clone configuration**:
   ```bash
   cd /tmp
   git clone https://github.com/kcalvelli/nixos_config
   cd nixos_config
   ```

3. **Run installer script**:
   ```bash
   sudo ./scripts/shell/install-axios.sh
   ```

4. **Or follow manual steps**:
   - Partition disk with disko
   - Generate host configuration
   - Install NixOS
   - Configure users

See [Manual Installation](#manual-installation-advanced) below for detailed steps.

## Post-Installation

### Understanding Your Configuration

The installer creates a **fresh, independent copy** of the axiOS configuration in `/etc/nixos`. This is **not a git clone** of the upstream repository—it's a completely new git repository initialized during installation.

**Important implications:**

- ✅ Your configuration is fully independent and under your control
- ✅ No risk of accidentally pushing to the upstream repository
- ✅ You can modify freely without affecting the original axiOS
- ⚠️ You won't automatically receive updates from upstream axiOS
- ⚠️ To get updates, you must manually pull changes or cherry-pick features

**Managing your configuration:**

1. **Keep local only** - Just use `/etc/nixos` and never push to a remote
2. **Create your own repository** - Push to GitHub/GitLab for backup and multi-machine sync:
   ```bash
   cd /etc/nixos
   git remote add origin https://github.com/YOURUSERNAME/your-nixos-config
   git push -u origin main
   ```
3. **Fork axiOS** - Fork the repository on GitHub, then change the remote:
   ```bash
   cd /etc/nixos
   git remote add origin https://github.com/YOURUSERNAME/nixos_config
   git push -u origin main
   ```

**Updating from upstream axiOS:**

If you want to incorporate upstream changes later:

```bash
cd /etc/nixos
# Add upstream as a remote
git remote add upstream https://github.com/kcalvelli/nixos_config
git fetch upstream

# Option 1: Cherry-pick specific commits
git cherry-pick <commit-hash>

# Option 2: Merge upstream changes (may have conflicts)
git merge upstream/main

# Option 3: Rebase your changes on top of upstream
git rebase upstream/main
```

**Recommendation:** Most users should keep their configuration independent and only cherry-pick specific features they want from upstream updates.

### First Boot

1. **Log in with your user account** - Use the username and password you created during installation

2. **Verify installation**:
   ```bash
   # Check NixOS version
   nixos-version
   
   # Check hostname
   hostname
   
   # Verify your user has sudo access
   sudo -v
   ```

3. **Optional: Set up Secure Boot**:

   Secure Boot is **disabled by default** for fresh installations to ensure compatibility. To enable it:

   ```bash
   # Create and enroll Secure Boot keys
   sudo sbctl create-keys
   sudo sbctl enroll-keys -m  # -m keeps Microsoft keys for dual-boot
   
   # Verify keys are enrolled
   sudo sbctl status
   ```

   Then enable in your configuration:
   ```bash
   sudo vim /etc/nixos/hosts/yourhostname.nix
   ```

   Add to the `extraConfig` section:
   ```nix
   extraConfig = {
     # Enable secure boot
     boot.lanzaboote.enableSecureBoot = true;
   };
   ```

   Rebuild and reboot:
   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#yourhostname
   sudo reboot
   ```

   After reboot, enable Secure Boot in BIOS/UEFI settings.

4. **Optional: Customize configuration**:
   ```bash
   cd /etc/nixos
   # Edit your user file
   sudo vim modules/users/yourusername.nix
   # Edit host configuration
   sudo vim hosts/yourhostname.nix
   ```

5. **Apply changes** (if you made customizations):
   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#yourhostname
   ```

### Verify Installation

```bash
# Check NixOS version
nixos-version

# Check that your configuration is active
hostname  # Should show your hostname

# Verify flake configuration
nix flake show /etc/nixos
```

### Update System

```bash
# Update flake inputs
cd /etc/nixos
nix flake update

# Rebuild with new packages
sudo nixos-rebuild switch --flake .#YOURHOSTNAME
```

## Configuration Options

### Disk Layouts

The installer offers three layouts:

#### 1. Standard (ext4)
- Simple, fast
- No encryption
- Best for: Desktops, servers

**Layout:**
- 1GB ESP boot partition (FAT32)
- Swap partition (configurable size)
- Root partition (ext4, remaining space)

#### 2. Encrypted (LUKS + ext4)
- Full disk encryption
- Password required at boot
- Best for: Laptops, portable systems

**Layout:**
- 1GB ESP boot partition (FAT32, unencrypted)
- LUKS encrypted partition containing ext4 root
- Swapfile inside encrypted partition

#### 3. Btrfs with Subvolumes
- Snapshots, compression
- Advanced filesystem features
- Best for: Power users

**Layout:**
- 1GB ESP boot partition (FAT32)
- Swap partition (configurable size)
- Btrfs root with subvolumes:
  - `@` (root)
  - `@home`
  - `@nix`
  - `@snapshots`

### Feature Modules

Enable features during installation or later in your host config:

- **Desktop** - Niri compositor, Ghostty terminal, desktop apps
- **Development** - Editors, compilers, LSPs, dev tools
- **Gaming** - Steam, GameMode, Gamescope
- **Virtualization** - libvirt, containers, VMs
- **Services** - Caddy proxy, OpenWebUI (optional)

### Hardware Support

Automatically configured based on detection:

- **AMD CPU** - AMD microcode and optimizations
- **Intel CPU** - Intel microcode and optimizations
- **AMD GPU** - AMDGPU drivers, ROCm
- **Nvidia GPU** - Proprietary drivers
- **Intel GPU** - Mesa drivers

Vendor-specific optimizations:
- **System76** - system76-firmware, hardware optimizations
- **MSI** - MSI-specific quirks and settings

## Manual Installation (Advanced)

For complete control, follow these steps:

### 1. Partition Disk

```bash
# List disks
lsblk

# Choose a disko template
cd /tmp
git clone https://github.com/kcalvelli/nixos_config
cd nixos_config

# Create host directory
mkdir -p hosts/myhostname

# Copy and edit disko config
cp modules/disko/templates/standard-ext4.nix hosts/myhostname/disko.nix
vim hosts/myhostname/disko.nix  # Set device = "/dev/nvme0n1" or similar

# Apply disk configuration
sudo nix run github:nix-community/disko -- --mode disko hosts/myhostname/disko.nix
```

### 2. Create Host Configuration

```bash
# Copy template
cp hosts/TEMPLATE.nix hosts/myhostname.nix

# Edit configuration
vim hosts/myhostname.nix
```

Set:
- hostname
- hardware (cpu, gpu, vendor)
- modules to enable
- diskConfigPath

### 3. Register Host

```bash
# Edit hosts/default.nix
vim hosts/default.nix

# Add line:
# myhostname = mkSystem (import ./myhostname.nix { inherit lib; }).hostConfig;
```

### 4. Install NixOS

```bash
# Copy config to /mnt
mkdir -p /mnt/etc/nixos
cp -r ./* /mnt/etc/nixos/

# Install
sudo nixos-install --flake /mnt/etc/nixos#myhostname

# Set root password when prompted

# Reboot
reboot
```

### 5. Post-Install Configuration

See [Post-Installation](#post-installation) above.

## Troubleshooting

### Installation Fails

**Network issues:**
```bash
# Test connectivity
ping 1.1.1.1

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Configure manually
nmtui
```

**Disk partitioning fails:**
```bash
# Unmount any existing partitions
sudo umount -R /mnt
sudo swapoff -a

# Retry disko
sudo nix run github:nix-community/disko -- --mode disko hosts/HOSTNAME/disko.nix
```

**Disk partitioning fails in VM with floppy drive errors:**

If you see errors about `/dev/fd0`:

```bash
# Use virtio drives when running QEMU
nix run nixpkgs#qemu -- \
  -cdrom result/iso/*.iso \
  -drive file=test-disk.qcow2,format=qcow2,if=virtio \
  -m 4096 -enable-kvm -cpu host -smp 4
```

The installer filters out floppy drives automatically, but virtio provides better compatibility.

**Out of disk space during build:**
- Installation requires downloading ~2-5GB of packages
- Ensure target disk has at least 20GB free

### Boot Issues

**System doesn't boot:**
- Check boot order in BIOS
- Verify Secure Boot is disabled (for installer)
- Check that bootloader was installed correctly

**Post-installation: Secure Boot Setup (Optional):**

Secure Boot is **disabled by default** on fresh installations to ensure compatibility.
After your first successful boot, you can optionally enable it:

```bash
# 1. Boot into your new system and log in

# 2. Create and enroll Secure Boot keys
sudo sbctl create-keys
sudo sbctl enroll-keys -m  # -m keeps Microsoft keys for dual-boot

# 3. Check Secure Boot status
sudo sbctl status

# 4. Enable in your host configuration
sudo vim /etc/nixos/hosts/YOURHOSTNAME.nix

# Add to extraConfig section:
# boot.lanzaboote.enableSecureBoot = true;

# 5. Rebuild system
sudo nixos-rebuild switch --flake /etc/nixos#YOURHOSTNAME

# 6. Reboot and enable Secure Boot in BIOS/UEFI settings
sudo reboot
```

**Encryption password not accepted:**
- Ensure keyboard layout is correct
- Try different keyboard if available
- Caps Lock may be on

**Stuck at "Loading initial ramdisk":**
- Usually indicates kernel panic
- Check disk encryption was configured correctly
- Verify hardware compatibility

### Hardware Not Detected

**WiFi not working:**
```bash
# Check if WiFi adapter is detected
ip link

# Load firmware
sudo modprobe iwlwifi  # For Intel
sudo modprobe ath10k   # For Atheros

# Some adapters need non-free firmware
# Add to configuration:
# hardware.enableRedistributableFirmware = true;
```

**Graphics issues:**
```bash
# Check GPU detection
lspci | grep -i vga

# For Nvidia, may need to:
# - Disable nouveau
# - Enable proprietary drivers in config
```

**Sound not working:**
```bash
# Check audio devices
aplay -l

# May need to set default device
# PulseAudio/PipeWire config in modules/system/sound.nix
```

### Getting Help

- **GitHub Issues**: [Report bugs](https://github.com/kcalvelli/nixos_config/issues)
- **NixOS Discourse**: [Ask questions](https://discourse.nixos.org/)
- **NixOS Wiki**: [Search docs](https://nixos.wiki/)
- **Configuration Docs**: See README and module READMEs

## Next Steps

After installation:

1. **Customize configuration** - Edit your host config and modules
2. **Add packages** - See `docs/PACKAGES.md` for organization
3. **Configure desktop** - Niri compositor settings in `home/desktops/niri/`
4. **Set up development** - Dev shells in `devshells.nix`
5. **Explore modules** - Each module has a README explaining its purpose

## See Also

- [Building ISO](BUILDING_ISO.md) - Create custom installer
- [Adding Hosts](ADDING_HOSTS.md) - Add more machines
- [Package Organization](PACKAGES.md) - Where to put packages
- [Main README](../README.md) - Repository overview
