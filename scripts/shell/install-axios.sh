#!/usr/bin/env bash
# axiOS Automated Installer v1.0
# https://github.com/kcalvelli/axios

set -euo pipefail

AXIOS_REPO="https://github.com/kcalvelli/axios"
CONFIG_DIR="/tmp/axios"

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
HARDWARE_VENDOR="null"
FORM_FACTOR=""
ENABLE_DESKTOP="true"
ENABLE_DEV="true"
ENABLE_GAMING="false"
ENABLE_SERVICES="false"
ENABLE_VIRT="false"
ENABLE_LIBVIRT="false"
ENABLE_CONTAINERS="false"
SWAP_SIZE="8G"
USERNAME=""
FULL_NAME=""
USER_EMAIL=""

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

select_hardware_vendor() {
  step "Hardware vendor (optional optimization)"
  echo ""
  echo "Select hardware vendor for specialized optimizations:"
  echo "  1) Generic (no vendor-specific settings)"
  echo "  2) MSI (MSI motherboard - enables sensor support)"
  echo "  3) System76 (System76 laptop - Pangolin optimizations)"
  echo ""
  read -p "Choice [1-3, default: 1]: " VENDOR_CHOICE
  
  case ${VENDOR_CHOICE:-1} in
    1) HARDWARE_VENDOR="null" ;;
    2) 
      if [[ "$FORM_FACTOR" != "desktop" ]]; then
        warn "MSI optimization is typically for desktops, but proceeding..."
      fi
      HARDWARE_VENDOR='"msi"'
      ;;
    3) 
      if [[ "$FORM_FACTOR" != "laptop" ]]; then
        warn "System76 optimization is for laptops, but proceeding..."
      fi
      HARDWARE_VENDOR='"system76"'
      ;;
    *) error "Invalid choice" ;;
  esac
  
  info "Hardware vendor: $(echo $HARDWARE_VENDOR | tr -d '\"' | sed 's/null/generic/')"
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
  while true; do
    read -p "Swap size in GB [8]: " SWAP_INPUT
    if [[ -z "$SWAP_INPUT" ]]; then
      SWAP_SIZE="8G"
      break
    fi
    
    # Extract numeric part and unit
    if [[ "$SWAP_INPUT" =~ ^([0-9]+)([GgMmKk])?$ ]]; then
      local num="${BASH_REMATCH[1]}"
      local unit="${BASH_REMATCH[2]}"
      
      if [[ -z "$unit" ]]; then
        SWAP_SIZE="${num}G"
      else
        SWAP_SIZE="${num}${unit^^}"
      fi
      break
    else
      warn "Invalid swap size. Enter a number (e.g., 8, 16) or with unit (e.g., 8G, 4096M)"
      continue
    fi
  done
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

configure_user() {
  step "Configure user account"
  echo ""
  echo "Create your primary user account"
  echo ""
  
  # Username
  while true; do
    read -p "Username (lowercase, no spaces): " USERNAME
    
    if [[ -z "$USERNAME" ]]; then
      warn "Username cannot be empty"
      continue
    fi
    
    if [[ ! "$USERNAME" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
      warn "Invalid username. Must start with lowercase letter or underscore, contain only lowercase letters, numbers, underscore, hyphen"
      continue
    fi
    
    if [[ "$USERNAME" == "root" ]] || [[ "$USERNAME" == "nixos" ]]; then
      warn "Username '$USERNAME' is reserved"
      continue
    fi
    
    break
  done
  
  # Full name
  while true; do
    read -p "Full name: " FULL_NAME
    
    if [[ -z "$FULL_NAME" ]]; then
      warn "Full name cannot be empty"
      continue
    fi
    
    break
  done
  
  # Email (optional but recommended for git)
  read -p "Email address (optional, for git): " USER_EMAIL
  if [[ -z "$USER_EMAIL" ]]; then
    USER_EMAIL="${USERNAME}@${HOSTNAME}.local"
    info "Using default email: $USER_EMAIL"
  fi
  
  echo ""
  info "User configuration:"
  echo "  Username: $USERNAME"
  echo "  Full name: $FULL_NAME"
  echo "  Email: $USER_EMAIL"
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
  
  # Services
  read -p "Enable server services (Caddy proxy, etc.)? [y/N]: " response
  [[ "$response" =~ ^[Yy] ]] && ENABLE_SERVICES="true" || ENABLE_SERVICES="false"
  
  # Virtualization
  read -p "Enable virtualization (libvirt, containers)? [y/N]: " response
  [[ "$response" =~ ^[Yy] ]] && ENABLE_VIRT="true" || ENABLE_VIRT="false"
  
  # Virtualization details
  if [[ "$ENABLE_VIRT" == "true" ]]; then
    echo ""
    read -p "  Enable libvirt (KVM/QEMU VMs)? [Y/n]: " response
    [[ "$response" =~ ^[Nn] ]] && ENABLE_LIBVIRT="false" || ENABLE_LIBVIRT="true"
    
    read -p "  Enable containers (Podman)? [Y/n]: " response
    [[ "$response" =~ ^[Nn] ]] && ENABLE_CONTAINERS="false" || ENABLE_CONTAINERS="true"
  else
    ENABLE_LIBVIRT="false"
    ENABLE_CONTAINERS="false"
  fi
  
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
  echo "  User:"
  echo "    - Username:    $USERNAME"
  echo "    - Full name:   $FULL_NAME"
  echo "    - Email:       $USER_EMAIL"
  echo ""
  echo "  Hardware:"
  echo "    - CPU:         $CPU_VENDOR"
  echo "    - GPU:         $GPU_VENDOR"
  echo "    - Type:        $FORM_FACTOR"
  echo "    - Vendor:      $(echo $HARDWARE_VENDOR | tr -d '\"' | sed 's/null/generic/')"
  echo ""
  echo "  Features:"
  echo "    - Desktop:     $ENABLE_DESKTOP"
  echo "    - Development: $ENABLE_DEV"
  echo "    - Gaming:      $ENABLE_GAMING"
  echo "    - Services:    $ENABLE_SERVICES"
  echo "    - Virt:        $ENABLE_VIRT"
  if [[ "$ENABLE_VIRT" == "true" ]]; then
    echo "      - libvirt:   $ENABLE_LIBVIRT"
    echo "      - Containers: $ENABLE_CONTAINERS"
  fi
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
  
  # Clean up personal configurations that shouldn't be in a fresh install
  step "Cleaning up example configurations..."
  
  # Remove personal host configurations (keep only installer and templates)
  rm -f hosts/edge.nix hosts/pangolin.nix
  rm -rf hosts/edge hosts/pangolin
  
  # Remove personal user configurations (keep only templates and examples)
  rm -f modules/users/keith.nix
  
  # Clean hosts/default.nix to remove personal host registrations
  cat > hosts/default.nix <<'EOF'
# Simple version that uses host config files but explicit mapping
{ inputs, self, lib, ... }:
let
  # Helper to build nixos-hardware modules
  hardwareModules = hw:
    let
      hwMods = inputs.nixos-hardware.nixosModules;
    in
      lib.optional (hw.cpu or null == "amd") hwMods.common-cpu-amd
      ++ lib.optional (hw.cpu or null == "intel") hwMods.common-cpu-intel
      ++ lib.optional (hw.gpu or null == "amd") hwMods.common-gpu-amd
      ++ lib.optional (hw.gpu or null == "nvidia") hwMods.common-gpu-nvidia
      ++ lib.optional (hw.hasSSD or false) hwMods.common-pc-ssd
      ++ lib.optional (hw.isLaptop or false) hwMods.common-pc-laptop;
  
  # Helper to build module list for a host
  buildModules = hostCfg:
    let
      baseModules = [
        inputs.disko.nixosModules.disko
        inputs.niri.nixosModules.niri
        inputs.dankMaterialShell.nixosModules.greeter
        inputs.home-manager.nixosModules.home-manager
        inputs.determinate.nixosModules.default
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.vscode-server.nixosModules.default
      ];
      
      hwModules = hardwareModules hostCfg.hardware;
      
      ourModules = with self.nixosModules;
        lib.optional (hostCfg.modules.system or true) system
        ++ lib.optional (hostCfg.modules.desktop or false) desktop
        ++ lib.optional (hostCfg.modules.development or false) development
        ++ lib.optional (hostCfg.modules.services or false) services
        ++ lib.optional (hostCfg.modules.graphics or false) graphics
        ++ lib.optional (hostCfg.modules.networking or true) networking
        ++ lib.optional (hostCfg.modules.users or true) users
        ++ lib.optional (hostCfg.modules.virt or false) virt
        ++ lib.optional (hostCfg.modules.gaming or false) gaming
        # Hardware modules based on form factor and vendor
        ++ lib.optional (hostCfg.hardware.vendor == "msi") desktopHardware
        ++ lib.optional (hostCfg.hardware.vendor == "system76") laptopHardware
        # Generic hardware based on form factor (if no specific vendor)
        ++ lib.optional (
          (hostCfg.hardware.vendor or null == null) &&
          (hostCfg.formFactor or "" == "desktop")
        ) desktopHardware
        ++ lib.optional (
          (hostCfg.hardware.vendor or null == null) &&
          (hostCfg.formFactor or "" == "laptop")
        ) laptopHardware;
      
      hostModule = { config, lib, ... }: 
        let
          hwVendor = hostCfg.hardware.vendor or null;
          profile = hostCfg.homeProfile or "workstation";
          extraCfg = hostCfg.extraConfig or {};
          
          dynamicConfig = lib.mkMerge [
            extraCfg
            (lib.optionalAttrs ((hostCfg.modules.virt or false) && (hostCfg ? virt)) {
              virt = hostCfg.virt;
            })
            (lib.optionalAttrs ((hostCfg.modules.services or false) && (hostCfg ? services)) {
              services = hostCfg.services;
            })
            (lib.optionalAttrs (hwVendor == "msi") {
              hardware.desktop = {
                enable = true;
                enableMsiSensors = true;
              };
            })
            (lib.optionalAttrs (hwVendor == "system76") {
              hardware.laptop = {
                enable = true;
                enableSystem76 = true;
              };
            })
          ];
        in
        lib.mkMerge [
          {
            networking.hostName = hostCfg.hostname;
            
            home-manager.sharedModules = 
              if profile == "workstation" then [ self.homeModules.workstation ]
              else if profile == "laptop" then [ self.homeModules.laptop ]
              else [];
          }
          dynamicConfig
        ];
      
      diskModule = 
        if hostCfg ? diskConfigPath 
        then hostCfg.diskConfigPath
        else { 
          imports = [];
        };
    in
      baseModules ++ hwModules ++ ourModules ++ [ hostModule diskModule ];
  
  # Helper to create a system config
  mkSystem = hostCfg: inputs.nixpkgs.lib.nixosSystem {
    system = hostCfg.system or "x86_64-linux";
    specialArgs = {
      inherit inputs self;
      inherit (self) nixosModules homeModules;
    };
    modules = buildModules hostCfg;
  };
  
  # Minimal installer configuration
  installerModules = [
    inputs.disko.nixosModules.disko
    ./installer
  ];
in
{
  flake.nixosConfigurations = {
    # Installer ISO
    installer = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs self;
        inherit (self) nixosModules homeModules;
      };
      modules = installerModules;
    };
    
    # To add a new host:
    # 1. Create hosts/newhostname.nix with hostConfig
    # 2. Add: newhostname = mkSystem (import ./newhostname.nix { inherit lib; }).hostConfig;
  };
}
EOF
  
  info "Cleaned up personal configurations"
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
      vendor = $HARDWARE_VENDOR; # Set to "msi" or "system76" for vendor-specific optimizations
      cpu = "$CPU_VENDOR";
      gpu = "$GPU_VENDOR";
      hasSSD = true;
      isLaptop = $([ "$FORM_FACTOR" == "laptop" ] && echo "true" || echo "false");
    };
    
    modules = {
      system = true;
      desktop = $ENABLE_DESKTOP;
      development = $ENABLE_DEV;
      services = $ENABLE_SERVICES;
      graphics = true;
      networking = true;
      users = true;
      virt = $ENABLE_VIRT;
      gaming = $ENABLE_GAMING;
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
      libvirt.enable = $ENABLE_LIBVIRT;
      containers.enable = $ENABLE_CONTAINERS;
    };
    
    homeProfile = "workstation";
    
    extraConfig = {
      # Add any host-specific configuration here
    };
    
    diskConfigPath = ./$HOSTNAME/disko.nix;
  };
}
EOF

  # Create user configuration file
  cat > "$CONFIG_DIR/modules/users/$USERNAME.nix" <<EOF
# User: $USERNAME
# Auto-generated by axiOS installer on $(date -I)
{ self, config, ... }:
let
  username = "$USERNAME";
  fullName = "$FULL_NAME";
  email = "$USER_EMAIL";
  homeDir = "/home/\${username}";
in
{
  # Define the user for the system
  users.users.\${username} = {
    isNormalUser = true;
    description = fullName;
    extraGroups = [
      "networkmanager"
      "wheel"  # sudo access
EOF

  # Add conditional groups based on enabled features
  if [[ "$ENABLE_VIRT" == "true" ]]; then
    cat >> "$CONFIG_DIR/modules/users/$USERNAME.nix" <<'EOF'
      "libvirtd"  # Libvirt virtualization
      "kvm"       # KVM access
EOF
  fi

  cat >> "$CONFIG_DIR/modules/users/$USERNAME.nix" <<'EOF'
    ];
    # Password will be set during installation
    # Change with: passwd
  };

  # Home Manager configuration for the user
  home-manager.users.${username} = {
    home = {
      stateVersion = "24.05";
      homeDirectory = homeDir;
      username = username;
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowBroken = false;
        allowUnsupportedSystem = false;
      };
      overlays = [
        self.overlays.default
      ];
    };

    # User-specific git configuration
    programs.git.settings.user = {
      name = fullName;
      email = email;
    };
  };

  # Trust this user with nix operations
  nix.settings = {
    trusted-users = [ username ];
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
  echo "  - $CONFIG_DIR/modules/users/$USERNAME.nix"
}

partition_disk() {
  step "Partitioning disk with disko..."
  echo ""
  warn "This will now format $DISK_PATH - last chance to cancel!"
  sleep 3
  
  # Run disko with flake config for binary caches
  nix --experimental-features "nix-command flakes" \
    --option accept-flake-config true \
    run github:nix-community/disko/latest -- \
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
  mkdir -p /mnt/etc
  rm -rf /mnt/etc/nixos
  cp -aT "$CONFIG_DIR" /mnt/etc/nixos

  # Initialize as a fresh git repo to avoid any push risks
  # This creates an INDEPENDENT configuration, not a clone of the upstream repo
  # Users can manage this however they like:
  #   - Keep it local only
  #   - Push to their own repository
  #   - Manually merge upstream changes if desired
  # The flake requires files to be in git, so we create a fresh local repo
  cd /mnt/etc/nixos
  rm -rf .git
  git init
  git config user.name "axiOS Installer"
  git config user.email "installer@axios.local"
  git add -A
  git commit -m "Initial axiOS installation for $HOSTNAME"

  # Install with explicit cache configuration to avoid building from source
  # The --option accept-flake-config true is critical for using binary caches
  # This prevents building large packages like Niri from source
  info "Using binary caches to avoid building from source..."
  nixos-install --flake "/mnt/etc/nixos#$HOSTNAME" \
    --option accept-flake-config true \
    --option extra-substituters "https://cache.nixos.org https://niri.cachix.org https://numtide.cachix.org" \
    --option extra-trusted-public-keys "cache.nixos.org-1:6NCHdD59X431kS1gBOk6429S9g0f1NXtv+FIsf8Xma0= niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964= numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE=" \
    --no-root-password \
    || error "System installation failed"
  
  info "System installation complete!"
}

configure_users() {
  step "User configuration"
  echo ""
  info "Setting user passwords..."
  echo ""
  echo "The user '$USERNAME' has been created with sudo access."
  echo "Set a password for $USERNAME:"
  echo ""
  
  nixos-enter --root /mnt -c "passwd $USERNAME" || warn "Failed to set user password"
  
  echo ""
  info "Setting root password..."
  echo "Enter password for root user:"
  echo ""
  
  nixos-enter --root /mnt -c 'passwd root' || warn "Failed to set root password"
  
  echo ""
  info "User accounts configured successfully"
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
  echo -e "${CYAN}Important: Your Configuration${NC}"
  echo ""
  echo "  Your system configuration in /etc/nixos is a FRESH, INDEPENDENT copy."
  echo "  It is NOT a clone and will NOT receive automatic updates."
  echo ""
  echo "  You can:"
  echo "    • Keep it local and manage manually"
  echo "    • Push to your own GitHub/GitLab repository"  
  echo "    • Manually merge upstream axiOS changes as desired"
  echo ""
  echo -e "${CYAN}Your Account:${NC}"
  echo ""
  echo -e "  Username: ${GREEN}$USERNAME${NC}"
  echo "  You have sudo access (use 'sudo' command)"
  echo ""
  echo -e "${CYAN}Next steps:${NC}"
  echo ""
  echo "  1. Remove the installation media"
  echo -e "  2. Reboot:  ${GREEN}systemctl reboot${NC}"
  echo -e "  3. Log in as ${GREEN}$USERNAME${NC} with the password you set"
  echo "  4. Optional: Set up Secure Boot (see below)"
  echo "  5. Optional: Customize your system by editing /etc/nixos"
  echo ""
  echo -e "${CYAN}Secure Boot Setup (Optional):${NC}"
  echo ""
  echo "  Secure Boot is DISABLED by default for fresh installations."
  echo "  To enable it after your first boot:"
  echo ""
  echo "  1. Boot into your new system"
  echo "  2. Create and enroll keys:"
  echo -e "     ${GREEN}sudo nix run nixpkgs#sbctl create-keys${NC}"
  echo -e "     ${GREEN}sudo nix run nixpkgs#sbctl enroll-keys -m${NC}  # -m keeps Microsoft keys for dual-boot"
  echo ""
  echo "  3. Enable in your configuration:"
  echo -e "     Edit ${GREEN}/etc/nixos/hosts/$HOSTNAME.nix${NC}"
  echo "     Add to extraConfig section:"
  echo -e "     ${GREEN}boot.lanzaboote.enableSecureBoot = true;${NC}"
  echo ""
  echo "  4. Rebuild system:"
  echo -e "     ${GREEN}sudo nixos-rebuild switch --flake /etc/nixos#$HOSTNAME${NC}"
  echo ""
  echo "  5. Reboot and enable Secure Boot in BIOS/UEFI"
  echo ""
  echo -e "${CYAN}Configuration location:${NC} /etc/nixos"
  echo -e "${CYAN}Upstream Documentation:${NC} https://github.com/kcalvelli/axios"
  echo -e "${CYAN}Secure Boot Details:${NC} https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md"
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
  select_hardware_vendor
  select_disk
  select_disk_layout
  configure_hostname
  configure_user
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
