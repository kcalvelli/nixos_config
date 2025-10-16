# Desktop Module

System-level desktop environment configuration and shared desktop services.

## Purpose

Configures desktop environments (Cosmic, Wayland, Plasma), shared desktop services, and system-wide desktop applications that require privileged access.

## Package Organization

System packages in `default.nix`:
- **VPN Applications**: ProtonVPN (requires system networking)
- **Streaming/Recording**: OBS with plugins (hardware access)

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

- `cosmic.nix`: Cosmic desktop environment
- `plasma.nix`: KDE Plasma desktop
- `wayland/`: Wayland compositor configurations
