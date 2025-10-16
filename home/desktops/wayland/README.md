# Wayland Desktop Module

User-level Wayland-specific applications and services.

## Purpose

Provides Wayland compositor tools, launchers, screenshot utilities, and theming that are specific to Wayland environments.

## Package Organization

Packages are organized in `packages.nix` by category:
- **launchers**: Application launchers and input (fuzzel, wl-clipboard, wtype)
- **audio**: Audio control (playerctl, pavucontrol, cava)
- **screenshot**: Screenshot and color tools (grimblast, grim, slurp, hyprpicker)
- **themes**: GTK themes and icon packs (Colloid, Adwaita, Papirus)
- **fonts**: UI fonts (Inter, Material Symbols)
- **qt**: Qt configuration tools (qt6ct)
- **utilities**: Wayland utilities (qalculate, swaybg, imagemagick, libnotify)

## What Goes Here

**User Wayland packages:**
- Wayland-specific launchers and tools
- Screenshot utilities for wlroots compositors
- Wayland clipboard management
- Theme and appearance tools
- Audio/media control widgets

**System Wayland packages go to:** `modules/desktop/wayland/`

## Services

- `kdeconnect`: Phone integration with system tray indicator

## Sub-directories

- `common/`: Shared Wayland configurations
  - `apps.nix`: Wayland applications (uses `packages.nix`)
  - `theming.nix`: Theme configuration
  - `material-code-theme.nix`: Material Design theme
- `niri.nix`: Niri compositor configuration

## Usage

This module is automatically imported when Wayland is enabled in the desktop configuration. It complements system-level Wayland setup with user-specific tools and applications.

## Notes

- These tools are compositor-agnostic and work with Niri, Hyprland, Sway, etc.
- Screenshot tools (grimblast, grim, slurp) are wlroots-specific
- Qt theming requires both system and user-level configuration
