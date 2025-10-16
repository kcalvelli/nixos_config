# Gaming Module

System-level gaming infrastructure and services.

## Purpose

Configures Steam, GameMode, and system-level gaming tools that require privileged access or system-wide configuration.

## Package Organization

- **gamescope**: Wayland gaming compositor
- **Steam**: Configured via `programs.steam` with protontricks and custom packages
- **GameMode**: System optimization daemon

## What Goes Here

**System-level packages:**
- Gaming platform services (Steam)
- System performance optimization (GameMode, gamescope)
- Gaming-related system daemons

**User gaming tools go to:** `home/profiles/workstation/gaming.nix`

## Programs

### Steam
- Remote play and dedicated server firewall rules
- Protontricks for Windows compatibility
- Extra compatibility layers (proton-ge-bin)
- Gamescope session integration

### GameMode
- CPU scheduling optimization
- GPU performance mode (AMD-specific)
- Desktop notifications for game mode state
- Screensaver inhibition

## Firewall Configuration

Steam ports are automatically opened for:
- Remote Play
- Dedicated server hosting
