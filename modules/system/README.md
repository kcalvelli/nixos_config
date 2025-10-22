# System Module

Core system-level configuration and utilities that form the foundation of the OS.

## Purpose

Contains essential system utilities, filesystem tools, monitoring tools, and base system configuration needed by all machines.

## Package Organization

Packages are organized in `packages.nix` by category:
- **core**: Essential utilities (curl, wget, killall)
- **filesystem**: Mount and filesystem tools (sshfs, fuse, ntfs3g)
- **monitoring**: System information and monitoring (htop, lm_sensors)
- **archives**: Archive and compression tools (p7zip, unzip, unrar)
- **security**: Secret management and encryption (libsecret, openssl)
- **nix**: Nix ecosystem tools (fh)

## What Goes Here

**System-level packages:**
- Core utilities needed by the system or multiple users
- Filesystem and hardware tools
- System monitoring and diagnostics
- Base security tools

**User-specific alternatives go to:** `home/common/`

## Sub-modules

- `local.nix`: Locale and timezone configuration
- `nix.nix`: Nix and Flakes configuration
- `boot.nix`: Boot loader and kernel configuration
- `printing.nix`: Printing services
- `sound.nix`: Audio configuration
- `bluetooth.nix`: Bluetooth configuration
