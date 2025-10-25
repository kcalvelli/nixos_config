# Edge Disko Configuration

This directory contains the disko configuration for fresh installations of the edge system.

## Fresh Installation

If you need to reinstall edge from scratch:

1. Boot into NixOS installer
2. Clone this repository
3. Run disko to partition and format:
   ```bash
   sudo nix run github:nix-community/disko -- --mode disko hosts/edge/disko/default.nix
   ```
4. Install NixOS:
   ```bash
   sudo nixos-install --flake .#edge
   ```

## Current System

The running system uses `disks.nix` in the parent directory, which contains the actual UUIDs of the existing partitions. This is the normal NixOS approach for already-installed systems.

## Disk Layout

- **ESP**: 1GB FAT32 boot partition
- **Swap**: 16GB swap partition
- **Root**: Remaining space as ext4 with noatime, nodiratime, and discard options
