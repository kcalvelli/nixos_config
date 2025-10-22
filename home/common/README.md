# Home Common Module

User-level applications and configurations shared across all desktop environments and machine types.

## Purpose

Contains applications and configurations that are common to all user setups, regardless of desktop environment or machine profile.

## Package Organization

Packages are organized in `packages.nix` by category:
- **notes**: Note-taking and knowledge management (Obsidian)
- **communication**: Social and communication apps (Discord)
- **documents**: Document editors (Typora, LibreOffice)
- **media**: Media creation tools (Pitivi, Pinta, Inkscape)
- **viewers**: Media viewing apps (Shotwell, Loupe, Celluloid, Amberol)
- **utilities**: System utilities (Baobab, Swappy)
- **sync**: Cloud sync clients (Nextcloud)
- **fonts**: User fonts (Fira Code Nerd Font)

## What Goes Here

**User-level packages:**
- Desktop applications for daily use
- Productivity software
- Media creation and viewing tools
- Personal utilities
- User-specific fonts

**System-wide desktop apps go to:** `modules/desktop/`

## Sub-modules

- `security.nix`: User security settings (GPG, SSH)
- `browser/`: Browser configuration (Brave)
- `terminal/`: Terminal emulator and shell configurations
- `apps.nix`: General desktop applications (this module)
- `calendar.nix`: Calendar and sync (khal, vdirsyncer)

## Notes

- Browsers are configured in `browser/` subdirectory, not `apps.nix`
- Terminal tools are in `terminal/` subdirectory with dotfile configs
- This is the base layer imported by all profile types (laptop, workstation)
