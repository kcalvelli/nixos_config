# Pangolin Disko Configuration

This directory contains the disko configuration for fresh installations of the pangolin system.

## Fresh Installation

If you need to reinstall pangolin from scratch:

1. Boot into NixOS installer
2. Clone this repository
3. Run disko to partition, encrypt, and format:
   ```bash
   sudo nix run github:nix-community/disko -- --mode disko hosts/pangolin/disko/default.nix
   ```
   You'll be prompted for a LUKS passphrase during this step.

4. Install NixOS:
   ```bash
   sudo nixos-install --flake .#pangolin
   ```

## Current System

The running system uses `disks.nix` in the parent directory, which contains the actual UUIDs of the existing partitions and LUKS device. This is the normal NixOS approach for already-installed systems.

## Disk Layout

- **ESP**: 512MB FAT32 boot partition
- **LUKS**: Remaining space as LUKS-encrypted partition containing:
  - ext4 root filesystem with noatime, nodiratime, and discard options
  - 8GB swapfile (created post-install)
