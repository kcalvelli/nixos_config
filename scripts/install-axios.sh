#!/usr/bin/env bash
# axiOS Automated Installer v1.0
# https://github.com/kcalvelli/nixos_config

set -euo pipefail

AXIOS_REPO="https://github.com/kcalvelli/nixos_config"
CONFIG_DIR="/tmp/nixos_config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Global variables
HOSTNAME=""
DISK_PATH=""
DISKO_TEMPLATE=""
CPU_VENDOR=""
GPU_VENDOR=""
FORM_FACTOR=""
ENABLE_DESKTOP="true"
ENABLE_DEV="true"
ENABLE_GAMING="false"
ENABLE_VIRT="false"
SWAP_SIZE="8G"

banner() {
  clear
  echo -e "${CYAN}"
  cat << "EOF"
   ___  __  ___(_)___  ___  
  / _ `/ |/_/ / // _ \/ _ \ 
  \_,_/_/|_/_/_/ \___/___/ 
                           
  axiOS Automated Installer
  Modern NixOS Configuration
  
EOF
  echo -e "${NC}"
}

error() { 
  echo -e "${RED}ERROR: $1${NC}" >&2
  exit 1
}

info() { 
  echo -e "${GREEN}INFO:${NC} $1"
}

warn() { 
  echo -e "${YELLOW}WARN:${NC} $1"
}

step() {
  echo -e "${BLUE}==>${NC} $1"
}

check_root() {
  if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root (use: sudo $0)"
  fi
}

check_network() {
  step "Checking network connectivity..."
  if ping -c 1 -W 5 1.1.1.1 >/dev/null 2>&1; then
    info "Network connectivity verified"
  else
    error "No network connectivity. Please configure network first.
    
For WiFi, use: nmtui (NetworkManager TUI)
For wired: Should work automatically"
  fi
}

check_nixos_installer() {
  if [[ ! -f /etc/NIXOS ]]; then
    error "Not running on NixOS installer environment.
    
Please boot from NixOS installer ISO first."
  fi
}

detect_hardware() {
  step "Detecting hardware..."
  
  # CPU detection
  if grep -q "AMD" /proc/cpuinfo; then
    CPU_VENDOR="amd"
  elif grep -q "Intel" /proc/cpuinfo; then
    CPU_VENDOR="intel"
  else
    CPU_VENDOR="unknown"
  fi
  
  # GPU detection  
  if lspci 2>/dev/null | grep -i vga | grep -qi nvidia; then
    GPU_VENDOR="nvidia"
  elif lspci 2>/dev/null | grep -i vga | grep -qi amd; then
    GPU_VENDOR="amd"
  elif lspci 2>/dev/null | grep -i vga | grep -qi intel; then
    GPU_VENDOR="intel"
  else
    GPU_VENDOR="unknown"
  fi
  
  # Form factor detection
  if [[ -d /sys/class/power_supply/BAT* ]] || [[ -d /sys/class/power_supply/BAT0 ]]; then
    FORM_FACTOR="laptop"
  else
    FORM_FACTOR="desktop"
  fi
  
  info "Detected hardware:"
  echo "  - CPU: ${CPU_VENDOR^^}"
  echo "  - GPU: ${GPU_VENDOR^^}"
  echo "  - Form Factor: ${FORM_FACTOR^^}"
  echo ""
}

select_disk() {
  step "Available disks:"
  echo ""
  
  # Display disks with numbers, filtering out floppy drives, zram, and loop devices
  local disk_list=$(lsblk -dno NAME,SIZE,TYPE,MODEL | grep disk | grep -v "fd[0-9]" | grep -v "loop" | grep -v "zram")
  
  if [[ -z "$disk_list" ]]; then
    error "No suitable disks found. Ensure you have a disk attached to the VM."
  fi
  
  echo "$disk_list" | nl -w2 -s'. '
  
  echo ""
  read -p "Select disk number: " DISK_NUM
  
  SELECTED_DISK=$(echo "$disk_list" | sed -n "${DISK_NUM}p" | awk '{print $1}')
  
  if [[ -z "$SELECTED_DISK" ]]; then
    error "Invalid disk selection"
  fi
  
  DISK_PATH="/dev/$SELECTED_DISK"
  
  echo ""
  warn "⚠️  Selected disk: $DISK_PATH"
  echo ""
  lsblk "$DISK_PATH"
  echo ""
  
  read -p "❗ This will ERASE ALL DATA on $DISK_PATH. Type 'yes' to confirm: " CONFIRM
  if [[ "$CONFIRM" != "yes" ]]; then
    error "Installation cancelled by user"
  fi
}

select_disk_layout() {
  step "Select disk layout:"
  echo ""
  echo "  1) Standard (ext4, no encryption)"
  echo "     - Fast, simple"
  echo "     - Best for: Desktops, servers"
  echo ""
  echo "  2) Encrypted (LUKS + ext4) ⭐ RECOMMENDED FOR LAPTOPS"
  echo "     - Full disk encryption"
  echo "     - Password required at boot"
  echo "     - Best for: Laptops, portable systems"
  echo ""
  echo "  3) Btrfs with subvolumes"
  echo "     - Snapshots, compression"
  echo "     - Best for: Advanced users"
  echo ""
  
  read -p "Choice [1-3]: " LAYOUT_CHOICE
  
  case $LAYOUT_CHOICE in
    1) DISKO_TEMPLATE="standard-ext4" ;;
    2) DISKO_TEMPLATE="luks-ext4" ;;
    3) DISKO_TEMPLATE="btrfs-subvolumes" ;;
    *) error "Invalid choice" ;;
  esac
  
  info "Selected: $DISKO_TEMPLATE"
  
  # Ask for swap size
  echo ""
  read -p "Swap size in GB [8]: " SWAP_INPUT
  if [[ -z "$SWAP_INPUT" ]]; then
    SWAP_SIZE="8G"
  else
    if [[ "$SWAP_INPUT" =~ [GgMmKk]$ ]]; then
      SWAP_SIZE="${SWAP_INPUT^^}"
    else
      SWAP_SIZE="${SWAP_INPUT}G"
    fi
  fi
  info "Swap size: $SWAP_SIZE"
}

configure_hostname() {
  step "Configure hostname"
  echo ""
  echo "Enter a hostname for this system (e.g., 'workstation', 'laptop', 'mypc')"
  echo "Must contain only: lowercase letters, numbers, and hyphens"
  echo ""
  
  while true; do
    read -p "Hostname: " HOSTNAME
    
    if [[ -z "$HOSTNAME" ]]; then
      warn "Hostname cannot be empty"
      continue
    fi
    
    if [[ ! "$HOSTNAME" =~ ^[a-z0-9-]+$ ]]; then
      warn "Invalid hostname. Use only: lowercase letters, numbers, hyphens"
      continue
    fi
    
    break
  done
  
  info "Hostname: $HOSTNAME"
}

select_features() {
  step "Select features to enable"
  echo ""
  
  # Desktop
  read -p "Enable desktop environment (Niri compositor)? [Y/n]: " response
  [[ "$response" =~ ^[Nn] ]] && ENABLE_DESKTOP="false" || ENABLE_DESKTOP="true"
  
  # Development
  read -p "Enable development tools (editors, compilers, LSPs)? [Y/n]: " response
  [[ "$response" =~ ^[Nn] ]] && ENABLE_DEV="false" || ENABLE_DEV="true"
  
  # Gaming
  read -p "Enable gaming (Steam, GameMode, Gamescope)? [y/N]: " response
  [[ "$response" =~ ^[Yy] ]] && ENABLE_GAMING="true" || ENABLE_GAMING="false"
  
  # Virtualization
  read -p "Enable virtualization (libvirt, containers)? [y/N]: " response
  [[ "$response" =~ ^[Yy] ]] && ENABLE_VIRT="true" || ENABLE_VIRT="false"
  
  echo ""
  info "Feature selection complete"
}

show_summary() {
  echo ""
  echo -e "${CYAN}════════════════════════════════════════${NC}"
  echo -e "${CYAN}     Installation Summary${NC}"
  echo -e "${CYAN}════════════════════════════════════════${NC}"
  echo ""
  echo "  Hostname:        $HOSTNAME"
  echo "  Disk:            $DISK_PATH"
  echo "  Layout:          $DISKO_TEMPLATE"
  echo "  Swap:            $SWAP_SIZE"
  echo ""
  echo "  Hardware:"
  echo "    - CPU:         $CPU_VENDOR"
  echo "    - GPU:         $GPU_VENDOR"
  echo "    - Type:        $FORM_FACTOR"
  echo ""
  echo "  Features:"
  echo "    - Desktop:     $ENABLE_DESKTOP"
  echo "    - Development: $ENABLE_DEV"
  echo "    - Gaming:      $ENABLE_GAMING"
  echo "    - Virt:        $ENABLE_VIRT"
  echo ""
  echo -e "${CYAN}════════════════════════════════════════${NC}"
  echo ""
}

clone_config() {
  step "Cloning axiOS configuration..."
  
  if [[ -d "$CONFIG_DIR" ]]; then
    warn "Removing existing configuration directory"
    rm -rf "$CONFIG_DIR"
  fi
  
  git clone --depth 1 "$AXIOS_REPO" "$CONFIG_DIR" || error "Failed to clone repository"
  cd "$CONFIG_DIR"
  
  info "Configuration cloned successfully"
}

generate_host_config() {
  step "Generating host configuration..."

  mkdir -p "$CONFIG_DIR/hosts/$HOSTNAME"

  # Create host config file
  cat > "$CONFIG_DIR/hosts/$HOSTNAME.nix" <<EOF
# Host: $HOSTNAME
# Auto-generated by axiOS installer on $(date -I)
{ lib, ... }:
{
  hostConfig = {
    hostname = "$HOSTNAME";
    system = "x86_64-linux";
    formFactor = "$FORM_FACTOR";
    
    hardware = {
      vendor = null; # Set to "msi" or "system76" if applicable
      cpu = "$CPU_VENDOR";
      gpu = "$GPU_VENDOR";
      hasSSD = true;
      isLaptop = $([ "$FORM_FACTOR" == "laptop" ] && echo "true" || echo "false");
    };
    
    modules = {
      system = true;
      desktop = $ENABLE_DESKTOP;
      development = $ENABLE_DEV;
      services = false;
      graphics = true;
      networking = true;
      users = true;
      virt = $ENABLE_VIRT;
      gaming = $ENABLE_GAMING;
    };
    
    homeProfile = "workstation";
    
    extraConfig = {
      # Add any host-specific configuration here
    };
    
    diskConfigPath = ./$HOSTNAME/disko.nix;
  };
}
EOF

  # Create disko config by instantiating the selected template
  local disk_config="$CONFIG_DIR/hosts/$HOSTNAME/disko.nix"

  cat > "$disk_config" <<EOF
# Generated by axiOS installer on $(date -Iseconds)
import ../../modules/disko/templates/${DISKO_TEMPLATE}.nix {
  device = "$DISK_PATH";
  swapSize = "$SWAP_SIZE";
EOF

  if [[ "$DISKO_TEMPLATE" == "btrfs-subvolumes" ]]; then
    cat >> "$disk_config" <<'EOF'
  compression = "zstd";
EOF
  fi

  cat >> "$disk_config" <<'EOF'
}
EOF

  # Register host in hosts/default.nix
  # Add the new host to the nixosConfigurations
  local host_line="    $HOSTNAME = mkSystem (import ./$HOSTNAME.nix { inherit lib; }).hostConfig;"
  
  # Check if already exists
  if grep -q "^[[:space:]]*$HOSTNAME = " "$CONFIG_DIR/hosts/default.nix"; then
    warn "Host $HOSTNAME already exists in hosts/default.nix"
  else
    # Add before the comment about adding new hosts
    sed -i "/# To add a new host:/i\\$host_line" "$CONFIG_DIR/hosts/default.nix"
    info "Registered host in hosts/default.nix"
  fi
  
  info "Host configuration created:"
  echo "  - $CONFIG_DIR/hosts/$HOSTNAME.nix"
  echo "  - $CONFIG_DIR/hosts/$HOSTNAME/disko.nix"
}

partition_disk() {
  step "Partitioning disk with disko..."
  echo ""
  warn "This will now format $DISK_PATH - last chance to cancel!"
  sleep 3
  
  # Run disko with the latest command format
  # The device is already set in the config file via sed replacement above
  nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- \
    --mode destroy,format,mount \
    "$CONFIG_DIR/hosts/$HOSTNAME/disko.nix" \
    || error "Disk partitioning failed"
  
  info "Disk partitioned and mounted to /mnt successfully"
}

install_system() {
  step "Installing axiOS..."
  echo ""
  info "This will take 10-30 minutes depending on your internet connection"
  echo ""
  
  # Copy the configuration to /mnt for nixos-install
  mkdir -p /mnt/etc/nixos
  cp -r "$CONFIG_DIR"/* /mnt/etc/nixos/
  
  nixos-install --flake "/mnt/etc/nixos#$HOSTNAME" --no-root-password \
    || error "System installation failed"
  
  info "System installation complete!"
}

configure_users() {
  step "User configuration"
  echo ""
  info "Setting up root password..."
  echo "Enter password for root user:"
  
  nixos-enter --root /mnt -c 'passwd root' || warn "Failed to set root password"
  
  echo ""
  info "You can add additional users by editing:"
  echo "  /etc/nixos/modules/users/username.nix"
  echo ""
  echo "See the template at:"
  echo "  /etc/nixos/modules/users/README.md"
}

success_message() {
  clear
  echo -e "${GREEN}"
  cat << "EOF"
   ___                            _ 
  / __|_  _ __ __ ___ ______| |
  \__ \ || / _/ _/ -_|_-<_-<|_|
  |___/\_,_\__\__\___/__/__/(_)
                              
  Installation Complete! 🎉
EOF
  echo -e "${NC}"
  echo ""
  info "axiOS has been successfully installed!"
  echo ""
  echo -e "${CYAN}Next steps:${NC}"
  echo ""
  echo "  1. Remove the installation media"
  echo "  2. Reboot:  ${GREEN}systemctl reboot${NC}"
  echo "  3. Log in as root with the password you set"
  echo "  4. Add your user account (see /etc/nixos/modules/users/README.md)"
  echo "  5. Rebuild the system: ${GREEN}nixos-rebuild switch --flake /etc/nixos#$HOSTNAME${NC}"
  echo ""
  echo -e "${CYAN}Configuration location:${NC} /etc/nixos"
  echo -e "${CYAN}Documentation:${NC} https://github.com/kcalvelli/nixos_config"
  echo ""
  echo -e "${YELLOW}Press Enter to exit...${NC}"
  read
}

main() {
  banner
  
  # Pre-flight checks
  check_root
  check_nixos_installer
  check_network
  detect_hardware
  
  # User interaction
  select_disk
  select_disk_layout
  configure_hostname
  select_features
  
  # Show summary and confirm
  show_summary
  
  read -p "Proceed with installation? [y/N]: " PROCEED
  if [[ ! "$PROCEED" =~ ^[Yy] ]]; then
    echo ""
    info "Installation cancelled by user"
    exit 0
  fi
  
  # Installation process
  clone_config
  generate_host_config
  partition_disk
  install_system
  configure_users
  success_message
}

# Handle script arguments
case "${1:-}" in
  --help|-h)
    echo "axiOS Automated Installer"
    echo ""
    echo "Usage: sudo $0"
    echo ""
    echo "This script will guide you through installing axiOS on your system."
    echo "It will partition your disk, install NixOS with the axiOS configuration,"
    echo "and set up your system based on your preferences."
    echo ""
    exit 0
    ;;
  *)
    main "$@"
    ;;
esac
