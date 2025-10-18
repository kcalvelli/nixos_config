#!/usr/bin/env bash
# Add a new user to axiOS configuration
# Usage: ./add-user.sh [username]

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
USERS_MODULE_DIR="$ROOT_DIR/modules/users"
HOME_PROFILES_DIR="$ROOT_DIR/home/profiles"

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

# Get username
if [[ -n "${1:-}" ]]; then
  USERNAME="$1"
else
  echo "Enter username for the new user:"
  read -p "Username: " USERNAME
fi

# Validate username
if [[ -z "$USERNAME" ]]; then
  error "Username cannot be empty"
fi

if [[ ! "$USERNAME" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
  error "Invalid username. Must start with a letter or underscore, contain only lowercase letters, numbers, underscores, and hyphens"
fi

# Check if user module already exists
if [[ -f "$USERS_MODULE_DIR/$USERNAME.nix" ]]; then
  error "User '$USERNAME' already exists at $USERS_MODULE_DIR/$USERNAME.nix"
fi

step "Creating new user: $USERNAME"

# Ask for configuration details
echo ""
read -p "Full name: " FULL_NAME
if [[ -z "$FULL_NAME" ]]; then
  FULL_NAME="$USERNAME"
fi

echo ""
echo "User groups (comma-separated, e.g., wheel,networkmanager,docker):"
echo "Common groups:"
echo "  - wheel: sudo access"
echo "  - networkmanager: network configuration"
echo "  - video: GPU access"
echo "  - audio: audio devices"
echo "  - libvirtd: virtualization"
echo "  - docker: docker containers"
read -p "Groups [wheel,networkmanager]: " GROUPS_INPUT
GROUPS="${GROUPS_INPUT:-wheel,networkmanager}"

echo ""
echo "Shell:"
echo "  1) bash"
echo "  2) zsh"
echo "  3) fish"
read -p "Choice [1-3, default: 2]: " SHELL_CHOICE
case ${SHELL_CHOICE:-2} in
  1) SHELL="bash" ;;
  2) SHELL="zsh" ;;
  3) SHELL="fish" ;;
  *) error "Invalid choice" ;;
esac

echo ""
read -p "Enable home-manager for this user? [Y/n]: " ENABLE_HM
[[ "$ENABLE_HM" =~ ^[Nn] ]] && ENABLE_HM="false" || ENABLE_HM="true"

HOME_PROFILE=""
if [[ "$ENABLE_HM" == "true" ]]; then
  echo ""
  echo "Home-manager profile:"
  echo "  1) workstation"
  echo "  2) laptop"
  echo "  3) none (manual configuration)"
  read -p "Choice [1-3, default: 1]: " PROFILE_CHOICE
  case ${PROFILE_CHOICE:-1} in
    1) HOME_PROFILE="workstation" ;;
    2) HOME_PROFILE="laptop" ;;
    3) HOME_PROFILE="" ;;
    *) error "Invalid choice" ;;
  esac
fi

echo ""
read -p "Create user's home directory? [Y/n]: " CREATE_HOME
[[ "$CREATE_HOME" =~ ^[Nn] ]] && CREATE_HOME="false" || CREATE_HOME="true"

echo ""
read -p "Set initial password? [Y/n]: " SET_PASSWORD
if [[ "$SET_PASSWORD" =~ ^[Nn] ]]; then
  SET_PASSWORD="false"
  INITIAL_PASSWORD=""
else
  SET_PASSWORD="true"
  read -s -p "Initial password: " INITIAL_PASSWORD
  echo ""
  read -s -p "Confirm password: " INITIAL_PASSWORD_CONFIRM
  echo ""
  if [[ "$INITIAL_PASSWORD" != "$INITIAL_PASSWORD_CONFIRM" ]]; then
    error "Passwords do not match"
  fi
fi

# Convert groups to nix list
IFS=',' read -ra GROUPS_ARRAY <<< "$GROUPS"
GROUPS_NIX="[ "
for group in "${GROUPS_ARRAY[@]}"; do
  GROUPS_NIX+="\"$(echo "$group" | xargs)\" "
done
GROUPS_NIX+="]"

# Create user module
cat > "$USERS_MODULE_DIR/$USERNAME.nix" <<EOF
# User configuration for $USERNAME
{ config, pkgs, lib, ... }:
{
  users.users.$USERNAME = {
    isNormalUser = true;
    description = "$FULL_NAME";
    extraGroups = $GROUPS_NIX;
    shell = pkgs.$SHELL;
    createHome = $CREATE_HOME;
EOF

if [[ "$SET_PASSWORD" == "true" && -n "$INITIAL_PASSWORD" ]]; then
  # Hash the password
  HASHED_PASSWORD=$(mkpasswd -m sha-512 "$INITIAL_PASSWORD")
  cat >> "$USERS_MODULE_DIR/$USERNAME.nix" <<EOF
    hashedPassword = "$HASHED_PASSWORD";
EOF
else
  cat >> "$USERS_MODULE_DIR/$USERNAME.nix" <<EOF
    # initialPassword = "changeme";  # Uncomment and set a password
EOF
fi

cat >> "$USERS_MODULE_DIR/$USERNAME.nix" <<EOF
  };
EOF

if [[ "$ENABLE_HM" == "true" ]]; then
  cat >> "$USERS_MODULE_DIR/$USERNAME.nix" <<EOF

  # Home-manager configuration
  home-manager.users.$USERNAME = { config, pkgs, ... }: {
EOF

  if [[ -n "$HOME_PROFILE" ]]; then
    cat >> "$USERS_MODULE_DIR/$USERNAME.nix" <<EOF
    imports = [
      ../home/profiles/$HOME_PROFILE
    ];
EOF
  fi

  cat >> "$USERS_MODULE_DIR/$USERNAME.nix" <<EOF

    home.stateVersion = "24.11";
    
    # User-specific packages
    home.packages = with pkgs; [
      # Add user-specific packages here
    ];
    
    # User-specific programs
    programs = {
      # Configure user programs here
    };
  };
EOF
fi

cat >> "$USERS_MODULE_DIR/$USERNAME.nix" <<EOF
}
EOF

info "Created $USERS_MODULE_DIR/$USERNAME.nix"

# Check if users module has a default.nix that imports user files
if [[ -f "$USERS_MODULE_DIR/default.nix" ]]; then
  # Check if it already imports this user
  if grep -q "$USERNAME.nix" "$USERS_MODULE_DIR/default.nix"; then
    warn "User '$USERNAME' already imported in users/default.nix"
  else
    # Check if there's an imports list
    if grep -q "imports = \[" "$USERS_MODULE_DIR/default.nix"; then
      # Add to imports
      sed -i "/imports = \[/a\\    ./$USERNAME.nix" "$USERS_MODULE_DIR/default.nix"
      info "Added $USERNAME to users/default.nix imports"
    else
      warn "Could not find imports list in users/default.nix"
      echo ""
      info "Please add this to the imports in modules/users/default.nix:"
      echo "  ./$USERNAME.nix"
    fi
  fi
else
  warn "No default.nix found in users module"
  echo ""
  info "Please import this module in your host configuration or users module:"
  echo "  ./modules/users/$USERNAME.nix"
fi

echo ""
info "User '$USERNAME' created successfully!"
echo ""
echo "Next steps:"
echo "  1. Review and customize $USERS_MODULE_DIR/$USERNAME.nix"
if [[ "$SET_PASSWORD" == "false" ]]; then
  echo "  2. Set a password or hashedPassword for the user"
fi
echo "  $(( SET_PASSWORD == "false" ? 3 : 2 )). Import the user module in your configuration if not auto-imported"
echo "  $(( SET_PASSWORD == "false" ? 4 : 3 )). Rebuild your system: nixos-rebuild switch --flake .#<hostname>"
if [[ "$ENABLE_HM" == "true" ]]; then
  echo ""
  info "Home-manager is enabled for this user. Customize their home configuration in the file."
fi
echo ""
