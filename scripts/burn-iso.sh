#!/usr/bin/env bash
# Burn axiOS ISO to USB drive
# Usage: ./burn-iso.sh [device]

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

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

banner() {
  echo -e "${CYAN}"
  cat << "EOF"
    ___  __  ___(_)___  ___  
   / _ `/ |/_/ / // _ \/ _ \ 
   \_,_/_/|_/_/_/ \___/___/ 
                            
   axiOS USB Creator
   
EOF
  echo -e "${NC}"
}

check_root() {
  if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root (use: sudo $0)"
  fi
}

get_iso_path() {
  step "Looking for axiOS ISO..." >&2
  
  # Check if ISO already exists in result
  if [[ -L "$ROOT_DIR/result" ]] && [[ -d "$ROOT_DIR/result/iso" ]]; then
    local iso_file=$(find "$ROOT_DIR/result/iso" -name "*.iso" -type f 2>/dev/null | head -1)
    if [[ -n "$iso_file" ]]; then
      echo "$iso_file"
      return 0
    fi
  fi
  
  # Build ISO if not found
  step "ISO not found, building from flake..." >&2
  echo "" >&2
  info "This may take a few minutes..." >&2
  
  cd "$ROOT_DIR"
  if nix build .#iso; then
    local iso_file=$(find "$ROOT_DIR/result/iso" -name "*.iso" -type f 2>/dev/null | head -1)
    if [[ -n "$iso_file" ]]; then
      echo "$iso_file"
      return 0
    fi
  fi
  
  return 1
}

list_devices() {
  step "Available USB devices:"
  echo ""
  
  # List block devices, filtering for removable devices
  lsblk -dno NAME,SIZE,TYPE,TRAN,MODEL | grep -E "usb|removable" | nl -w2 -s'. ' || true
  
  echo ""
  echo "All block devices:"
  lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS,TRAN,MODEL
  echo ""
}

select_device() {
  if [[ -n "${1:-}" ]]; then
    DEVICE="$1"
    # Normalize device path
    if [[ ! "$DEVICE" =~ ^/dev/ ]]; then
      DEVICE="/dev/$DEVICE"
    fi
  else
    list_devices
    
    echo -e "${YELLOW}WARNING: Selecting wrong device will destroy data!${NC}"
    echo ""
    read -p "Enter device path (e.g., /dev/sdb or sdb): " DEVICE_INPUT
    
    if [[ -z "$DEVICE_INPUT" ]]; then
      error "No device specified"
    fi
    
    # Normalize device path
    if [[ ! "$DEVICE_INPUT" =~ ^/dev/ ]]; then
      DEVICE="/dev/$DEVICE_INPUT"
    else
      DEVICE="$DEVICE_INPUT"
    fi
  fi
  
  # Validate device exists
  if [[ ! -b "$DEVICE" ]]; then
    error "Device $DEVICE does not exist or is not a block device"
  fi
  
  # Check if device is mounted
  if mount | grep -q "^${DEVICE}"; then
    warn "Device $DEVICE has mounted partitions"
    echo ""
    mount | grep "^${DEVICE}"
    echo ""
    read -p "Unmount all partitions? [y/N]: " UNMOUNT
    if [[ "$UNMOUNT" =~ ^[Yy] ]]; then
      step "Unmounting partitions..."
      for partition in ${DEVICE}*[0-9]; do
        if mount | grep -q "^${partition}"; then
          umount "$partition" 2>/dev/null || true
        fi
      done
      info "Partitions unmounted"
    else
      error "Cannot proceed with mounted partitions"
    fi
  fi
  
  echo ""
  step "Selected device: $DEVICE"
  lsblk "$DEVICE" -o NAME,SIZE,TYPE,MOUNTPOINTS,TRAN,MODEL
  echo ""
}

confirm_burn() {
  local iso_path="$1"
  local iso_name=$(basename "$iso_path")
  local iso_size=$(du -h "$iso_path" | cut -f1)
  local device_size=$(lsblk -dno SIZE "$DEVICE")
  
  echo -e "${CYAN}════════════════════════════════════════${NC}"
  echo -e "${CYAN}     USB Creation Summary${NC}"
  echo -e "${CYAN}════════════════════════════════════════${NC}"
  echo ""
  echo "  ISO File:    $iso_name"
  echo "  ISO Size:    $iso_size"
  echo ""
  echo "  Device:      $DEVICE"
  echo "  Size:        $device_size"
  echo ""
  echo -e "${RED}⚠️  ALL DATA ON $DEVICE WILL BE DESTROYED!${NC}"
  echo ""
  echo -e "${CYAN}════════════════════════════════════════${NC}"
  echo ""
  
  read -p "Type 'yes' to confirm: " CONFIRM
  if [[ "$CONFIRM" != "yes" ]]; then
    info "Operation cancelled"
    exit 0
  fi
}

burn_iso() {
  local iso_path="$1"
  
  step "Writing ISO to $DEVICE..."
  echo ""
  info "This will take several minutes. Do not remove the device!"
  echo ""
  
  # Use dd with status=progress if available (GNU coreutils)
  if dd --help 2>&1 | grep -q "status=progress"; then
    dd if="$iso_path" of="$DEVICE" bs=4M conv=fsync status=progress
  else
    # Fallback for systems without status=progress
    dd if="$iso_path" of="$DEVICE" bs=4M conv=fsync
  fi
  
  echo ""
  step "Syncing filesystems..."
  sync
  
  echo ""
  info "ISO successfully written to $DEVICE"
}

verify_burn() {
  echo ""
  read -p "Verify written data? (recommended but slow) [y/N]: " VERIFY
  
  if [[ "$VERIFY" =~ ^[Yy] ]]; then
    step "Verifying written data..."
    echo ""
    info "This will take several minutes..."
    
    local iso_path="$1"
    local iso_size=$(stat -c%s "$iso_path")
    local block_count=$((iso_size / 4194304))
    
    if dd if="$DEVICE" bs=4M count=$block_count 2>/dev/null | md5sum > /tmp/device_md5.txt && \
       md5sum "$iso_path" > /tmp/iso_md5.txt; then
      
      local device_md5=$(cut -d' ' -f1 /tmp/device_md5.txt)
      local iso_md5=$(cut -d' ' -f1 /tmp/iso_md5.txt)
      
      if [[ "$device_md5" == "$iso_md5" ]]; then
        info "Verification successful! Data written correctly."
      else
        warn "Verification failed! MD5 checksums do not match."
        echo "  ISO:    $iso_md5"
        echo "  Device: $device_md5"
      fi
      
      rm -f /tmp/device_md5.txt /tmp/iso_md5.txt
    else
      warn "Verification failed"
    fi
  fi
}

eject_device() {
  echo ""
  read -p "Eject device? [Y/n]: " EJECT
  
  if [[ ! "$EJECT" =~ ^[Nn] ]]; then
    step "Ejecting device..."
    eject "$DEVICE" 2>/dev/null || sync
    info "Device can be safely removed"
  fi
}

success_message() {
  echo ""
  echo -e "${GREEN}"
  cat << "EOF"
    ___                            _ 
   / __|_  _ __ __ ___ ______| |
   \__ \ || / _/ _/ -_|_-<_-<|_|
   |___/\_,_\__\__\___/__/__/(_)
                               
   USB Drive Created! 🎉
EOF
  echo -e "${NC}"
  echo ""
  info "Your axiOS USB installer is ready!"
  echo ""
  echo "Next steps:"
  echo "  1. Insert the USB drive into target computer"
  echo "  2. Boot from USB (usually F12, F2, or Del to enter boot menu)"
  echo "  3. Follow the installation instructions"
  echo ""
}

main() {
  banner
  check_root
  
  # Get ISO path
  ISO_PATH=$(get_iso_path)
  if [[ -z "$ISO_PATH" ]]; then
    error "Could not find or build axiOS ISO"
  fi
  
  info "Found ISO: $(basename "$ISO_PATH")"
  info "ISO size: $(du -h "$ISO_PATH" | cut -f1)"
  echo ""
  
  # Select device
  select_device "${1:-}"
  
  # Confirm operation
  confirm_burn "$ISO_PATH"
  
  # Burn ISO
  burn_iso "$ISO_PATH"
  
  # Optional verification
  verify_burn "$ISO_PATH"
  
  # Optional eject
  eject_device
  
  # Success
  success_message
}

# Handle script arguments
case "${1:-}" in
  --help|-h)
    echo "axiOS USB Creator"
    echo ""
    echo "Usage: sudo $0 [device]"
    echo ""
    echo "Arguments:"
    echo "  device    Optional. Target device (e.g., /dev/sdb or sdb)"
    echo ""
    echo "Examples:"
    echo "  sudo $0              # Interactive mode"
    echo "  sudo $0 /dev/sdb     # Burn to /dev/sdb"
    echo "  sudo $0 sdb          # Burn to /dev/sdb (auto-adds /dev/)"
    echo ""
    echo "This script will:"
    echo "  1. Build the axiOS ISO if needed (using 'nix build .#iso')"
    echo "  2. Write the ISO to the specified USB device"
    echo "  3. Optionally verify the written data"
    echo ""
    echo "⚠️  WARNING: All data on the target device will be destroyed!"
    echo ""
    exit 0
    ;;
  *)
    main "$@"
    ;;
esac
