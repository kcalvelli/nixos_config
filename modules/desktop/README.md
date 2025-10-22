# Desktop Module

System-level desktop environment configuration and shared desktop services.

## Purpose

Configures Wayland compisitor, shared desktop services, and system-wide desktop applications that require privileged access.

## Package Organization

Packages organized in `packages.nix` by category:
- **vpn**: VPN applications (ProtonVPN)
- **streaming**: OBS with plugins for recording/streaming

See `packages.nix` for the complete package list.

## What Goes Here

**System-level packages:**
- Desktop apps requiring privileged access
- VPN clients with system network configuration
- Recording/streaming software needing hardware access
- Desktop environment core packages

**User desktop apps go to:** `home/common/apps.nix` or `home/desktops/`

## Services

- udisks2: Disk management
- system76-scheduler: Process scheduling optimization
- flatpak: Flatpak application support
- fwupd: Firmware updates
- libinput: Input device configuration
- power-profiles-daemon: Power management

## Programs

- corectrl: GPU control (requires polkit)
- kdeconnect: Phone integration (system service)
- localsend: File sharing with firewall rules

## Sub-modules
- `wayland/`: Wayland compositor configurations
