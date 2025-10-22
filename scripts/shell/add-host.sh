#!/usr/bin/env bash
# Add a new host to axiOS configuration
# Usage: ./add-host.sh [hostname]

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
HOSTS_DIR="$ROOT_DIR/hosts"

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

# Get hostname
if [[ -n "${1:-}" ]]; then
  HOSTNAME="$1"
else
  echo "Enter hostname for the new host:"
  read -p "Hostname: " HOSTNAME
fi

# Validate hostname
if [[ -z "$HOSTNAME" ]]; then
  error "Hostname cannot be empty"
fi

if [[ ! "$HOSTNAME" =~ ^[a-z0-9-]+$ ]]; then
  error "Invalid hostname. Use only: lowercase letters, numbers, hyphens"
fi

# Check if host already exists
if [[ -f "$HOSTS_DIR/$HOSTNAME.nix" ]]; then
  error "Host '$HOSTNAME' already exists at $HOSTS_DIR/$HOSTNAME.nix"
fi

step "Creating new host: $HOSTNAME"

# Ask for configuration details
echo ""
echo "System architecture:"
echo "  1) x86_64-linux (64-bit Intel/AMD)"
echo "  2) aarch64-linux (64-bit ARM)"
read -p "Choice [1-2, default: 1]: " ARCH_CHOICE
case ${ARCH_CHOICE:-1} in
  1) SYSTEM="x86_64-linux" ;;
  2) SYSTEM="aarch64-linux" ;;
  *) error "Invalid choice" ;;
esac

echo ""
echo "Form factor:"
echo "  1) desktop"
echo "  2) laptop"
echo "  3) server"
read -p "Choice [1-3, default: 1]: " FORM_CHOICE
case ${FORM_CHOICE:-1} in
  1) FORM_FACTOR="desktop" ;;
  2) FORM_FACTOR="laptop" ;;
  3) FORM_FACTOR="server" ;;
  *) error "Invalid choice" ;;
esac

echo ""
echo "CPU vendor:"
echo "  1) amd"
echo "  2) intel"
read -p "Choice [1-2, default: 1]: " CPU_CHOICE
case ${CPU_CHOICE:-1} in
  1) CPU="amd" ;;
  2) CPU="intel" ;;
  *) error "Invalid choice" ;;
esac

echo ""
echo "GPU vendor:"
echo "  1) amd"
echo "  2) nvidia"
echo "  3) intel"
read -p "Choice [1-3, default: 1]: " GPU_CHOICE
case ${GPU_CHOICE:-1} in
  1) GPU="amd" ;;
  2) GPU="nvidia" ;;
  3) GPU="intel" ;;
  *) error "Invalid choice" ;;
esac

echo ""
echo "Hardware vendor (optional):"
echo "  1) none (generic hardware)"
echo "  2) msi (MSI motherboard - desktop only)"
echo "  3) system76 (System76 laptop - Pangolin 12)"
read -p "Choice [1-3, default: 1]: " VENDOR_CHOICE
case ${VENDOR_CHOICE:-1} in
  1) VENDOR="null" ;;
  2) VENDOR="\"msi\"" ;;
  3) VENDOR="\"system76\"" ;;
  *) error "Invalid choice" ;;
esac

echo ""
read -p "Has SSD? [Y/n]: " HAS_SSD
[[ "$HAS_SSD" =~ ^[Nn] ]] && HAS_SSD="false" || HAS_SSD="true"

IS_LAPTOP=$([[ "$FORM_FACTOR" == "laptop" ]] && echo "true" || echo "false")

echo ""
echo "Modules to enable:"
read -p "  Desktop environment? [Y/n]: " MOD_DESKTOP
[[ "$MOD_DESKTOP" =~ ^[Nn] ]] && MOD_DESKTOP="false" || MOD_DESKTOP="true"

read -p "  Development tools? [Y/n]: " MOD_DEV
[[ "$MOD_DEV" =~ ^[Nn] ]] && MOD_DEV="false" || MOD_DEV="true"

read -p "  Server services? [y/N]: " MOD_SERVICES
[[ "$MOD_SERVICES" =~ ^[Yy] ]] && MOD_SERVICES="true" || MOD_SERVICES="false"

read -p "  Gaming? [y/N]: " MOD_GAMING
[[ "$MOD_GAMING" =~ ^[Yy] ]] && MOD_GAMING="true" || MOD_GAMING="false"

read -p "  Virtualization? [y/N]: " MOD_VIRT
[[ "$MOD_VIRT" =~ ^[Yy] ]] && MOD_VIRT="true" || MOD_VIRT="false"

# Virtualization details
if [[ "$MOD_VIRT" == "true" ]]; then
  echo ""
  read -p "    Enable libvirt (KVM/QEMU VMs)? [Y/n]: " MOD_LIBVIRT
  [[ "$MOD_LIBVIRT" =~ ^[Nn] ]] && MOD_LIBVIRT="false" || MOD_LIBVIRT="true"
  
  read -p "    Enable containers (Podman)? [Y/n]: " MOD_CONTAINERS
  [[ "$MOD_CONTAINERS" =~ ^[Nn] ]] && MOD_CONTAINERS="false" || MOD_CONTAINERS="true"
else
  MOD_LIBVIRT="false"
  MOD_CONTAINERS="false"
fi

echo ""
echo "Home-manager profile:"
echo "  1) workstation"
echo "  2) laptop"
read -p "Choice [1-2, default: 1]: " PROFILE_CHOICE
case ${PROFILE_CHOICE:-1} in
  1) HOME_PROFILE="workstation" ;;
  2) HOME_PROFILE="laptop" ;;
  *) error "Invalid choice" ;;
esac

# Create host directory
mkdir -p "$HOSTS_DIR/$HOSTNAME"

# Create host configuration file
cat > "$HOSTS_DIR/$HOSTNAME.nix" <<EOF
# Host: $HOSTNAME
{ lib, ... }:
{
  hostConfig = {
    # Basic identification
    hostname = "$HOSTNAME";
    system = "$SYSTEM";
    formFactor = "$FORM_FACTOR";
    
    # Hardware configuration
    hardware = {
      vendor = $VENDOR;
      cpu = "$CPU";
      gpu = "$GPU";
      hasSSD = $HAS_SSD;
      isLaptop = $IS_LAPTOP;
    };
    
    # NixOS modules to enable
    modules = {
      system = true;
      desktop = $MOD_DESKTOP;
      development = $MOD_DEV;
      services = $MOD_SERVICES;
      graphics = true;
      networking = true;
      users = true;
      virt = $MOD_VIRT;
      gaming = $MOD_GAMING;
    };
    
    # Services to enable (optional)
    services = {
      # caddy-proxy.enable = true;
      # openwebui.enable = true;
      # ntop.enable = true;
      # hass.enable = true;
      # mqtt.enable = true;
    };
    
    # Virtualization configuration (optional)
    virt = {
      libvirt.enable = $MOD_LIBVIRT;
      containers.enable = $MOD_CONTAINERS;
    };
    
    # Home-manager profile
    homeProfile = "$HOME_PROFILE";
    
    # Optional: Extra NixOS configuration
    extraConfig = {
      # Add host-specific configuration here
    };
    
    # Disk configuration path
    diskConfigPath = ./$HOSTNAME/disks.nix;
  };
}
EOF

info "Created $HOSTS_DIR/$HOSTNAME.nix"

# Create placeholder disk configuration
cat > "$HOSTS_DIR/$HOSTNAME/disks.nix" <<EOF
# Disk configuration for $HOSTNAME
# TODO: Configure your disk layout
# See examples in other host directories or modules/disko/templates/
{ ... }:
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";  # UPDATE THIS
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
EOF

info "Created $HOSTS_DIR/$HOSTNAME/disks.nix (placeholder)"

# Register host in hosts/default.nix
HOST_LINE="    $HOSTNAME = mkSystem (import ./$HOSTNAME.nix { inherit lib; }).hostConfig;"

if grep -q "^[[:space:]]*$HOSTNAME = " "$HOSTS_DIR/default.nix"; then
  warn "Host '$HOSTNAME' already registered in hosts/default.nix"
else
  # Add before the comment about adding new hosts
  if grep -q "# To add a new host:" "$HOSTS_DIR/default.nix"; then
    sed -i "/# To add a new host:/i\\$HOST_LINE" "$HOSTS_DIR/default.nix"
    info "Registered host in hosts/default.nix"
  else
    warn "Could not find insertion point in hosts/default.nix"
    echo ""
    info "Please add this line manually to the nixosConfigurations in hosts/default.nix:"
    echo "  $HOST_LINE"
  fi
fi

echo ""
info "Host '$HOSTNAME' created successfully!"
echo ""
echo "Next steps:"
echo "  1. Edit $HOSTS_DIR/$HOSTNAME/disks.nix with your disk configuration"
echo "  2. Customize $HOSTS_DIR/$HOSTNAME.nix as needed"
echo "  3. Build the system: nixos-rebuild switch --flake .#$HOSTNAME"
echo ""
