# axiOS Documentation

Welcome to the axiOS documentation. This guide will help you install, configure, and maintain your NixOS system.

## Documentation Overview

| Document | Purpose | When to Read |
|----------|---------|--------------|
| [INSTALLATION.md](INSTALLATION.md) | Install axiOS on your machine | **Start here** for new installations |
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md) | Quick command reference | Quick lookups and common tasks |
| [PACKAGES.md](PACKAGES.md) | Package organization guide | Before adding new packages |
| [ADDING_HOSTS.md](ADDING_HOSTS.md) | Multi-machine management | Managing multiple systems |
| [BUILDING_ISO.md](BUILDING_ISO.md) | Custom ISO creation | Building your own installer |
| [NIRI_WALLPAPER.md](NIRI_WALLPAPER.md) | Desktop customization | Customizing Niri compositor |

## Quick Start

### New Users

1. **Download the installer**: Get the latest ISO from [GitHub Releases](https://github.com/kcalvelli/axios/releases)
2. **Create bootable USB**: Write the ISO to a USB drive
3. **Install**: Boot from USB and run the automated installer
4. **Read**: [INSTALLATION.md](INSTALLATION.md) for detailed instructions

### Existing Users

- **Update system**: `cd /etc/nixos && nix flake update && sudo nixos-rebuild switch --flake .#HOSTNAME`
- **Add packages**: See [PACKAGES.md](PACKAGES.md) for organization guidelines
- **Add new machine**: See [ADDING_HOSTS.md](ADDING_HOSTS.md)
- **Quick reference**: See [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

## Installation & Setup

### 📦 [INSTALLATION.md](INSTALLATION.md)
**Complete installation guide from start to finish**

Topics covered:
- Downloading and preparing the installer ISO
- Creating bootable installation media
- Installing to VMs (VMware, VirtualBox, QEMU, etc.)
- Installing to bare metal
- Automated vs manual installation
- Post-installation setup and configuration
- Troubleshooting common issues

**Start here if you're installing axiOS for the first time.**

### 🔨 [BUILDING_ISO.md](BUILDING_ISO.md)
**Build and customize the axiOS installer ISO**

Topics covered:
- Building the ISO from source
- Customizing packages and branding
- Testing in VMs and QEMU
- CI/CD integration for automated builds
- Creating custom variations

**For developers who want to build or customize the installer.**

### ⚡ [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
**Fast command reference for common operations**

Quick access to:
- ISO build and testing commands
- VM testing procedures
- Installer customization
- Common troubleshooting fixes
- Frequently used operations

**For quick lookups without reading full documentation.**

## Configuration & Maintenance

### 📚 [PACKAGES.md](PACKAGES.md)
**Package organization philosophy and best practices**

Learn about:
- System vs Home Manager package placement
- Module organization structure
- Decision trees for adding packages
- Maintaining categorized package lists
- Best practices for package management

**Read this before adding new packages to understand where they belong.**

### 🖥️ [ADDING_HOSTS.md](ADDING_HOSTS.md)
**Managing multiple machines with axiOS**

Covers:
- Adding new hosts to your configuration
- Host configuration structure
- Hardware-specific settings
- Template usage and examples
- Multi-machine best practices

**For users managing axiOS across multiple machines.**

### 🎨 [NIRI_WALLPAPER.md](NIRI_WALLPAPER.md)
**Desktop customization with Niri compositor**

Includes:
- Wallpaper blur effects for overview mode
- DankMaterialShell integration
- Automatic wallpaper script setup
- Troubleshooting desktop issues

**For desktop users wanting to customize their Niri experience.**

## Common Tasks

### Updating Your System

```bash
# Update flake inputs (get latest packages)
cd /etc/nixos
nix flake update

# Rebuild and switch to new configuration
sudo nixos-rebuild switch --flake .#HOSTNAME

# Optionally, clean up old generations
sudo nix-collect-garbage -d
```

### Adding a New Package

1. Determine if it's a system or user package (see [PACKAGES.md](PACKAGES.md))
2. Add to appropriate `packages.nix` file in `modules/` or `home/`
3. Rebuild: `sudo nixos-rebuild switch --flake /etc/nixos#HOSTNAME`

### Adding a New Machine

1. Copy the template: `cp hosts/TEMPLATE.nix hosts/newhost.nix`
2. Edit configuration with hostname, hardware, and features
3. Add to `hosts/default.nix`
4. Create disk config in `hosts/newhost/disko/`
5. See [ADDING_HOSTS.md](ADDING_HOSTS.md) for details

### Customizing Desktop

- Edit Niri config: `home/desktops/niri/`
- Set wallpaper with blur: `~/scripts/set-wallpaper-blur.sh /path/to/image.jpg`
- See [NIRI_WALLPAPER.md](NIRI_WALLPAPER.md) for desktop customization

## Screenshots

Visual examples of the axiOS desktop:

- **Niri Overview**: `screenshots/overview.png` - Workspace overview mode
- **Dropdown Terminal**: `screenshots/dropdown.png` - Ghostty terminal
- **File Manager**: `screenshots/nautilus.png` - Themed file browser

## Repository Structure

```
axios/
├── flake.nix           # Flake configuration and inputs
├── hosts/              # Per-machine configurations
│   ├── TEMPLATE.nix            # Template for new hosts
│   ├── EXAMPLE-simple.nix      # Simple example host
│   ├── EXAMPLE-organized.nix   # Organized example host
│   └── installer/              # Installer ISO configuration
├── modules/            # NixOS system modules
│   ├── system/        # Core system utilities
│   ├── desktop/       # Desktop environments (Niri, Wayland)
│   ├── development/   # Development tools and environments
│   ├── disko/         # Disk layout templates
│   ├── hardware/      # Hardware-specific configs (desktop/laptop)
│   ├── gaming/        # Gaming support (Steam, GameMode)
│   ├── services/      # System services
│   └── users/         # User account definitions
├── home/               # Home Manager configurations
│   ├── common/        # Shared user configurations
│   ├── desktops/      # Desktop-specific configs (Niri, Wayland)
│   ├── profiles/      # User profiles (workstation, laptop)
│   └── resources/     # Themes and resources
├── scripts/            # Automation scripts
│   ├── install-axios.sh  # Automated installer
│   ├── add-host.sh       # Create new host config
│   ├── add-user.sh       # Create new user
│   └── burn-iso.sh       # Create bootable USB
├── devshells/          # Development environments (Rust, Zig, QML, etc.)
├── pkgs/               # Custom package definitions
└── docs/               # Documentation (you are here)
```

Each module directory contains a `README.md` explaining its purpose and organization.

## Help and Support

### Getting Help

1. **Check documentation**: Start with the relevant guide above
2. **Search issues**: Look through [existing GitHub issues](https://github.com/kcalvelli/nixos_config/issues)
3. **Ask the community**: Post on [NixOS Discourse](https://discourse.nixos.org/)
4. **Report bugs**: Create a [new issue](https://github.com/kcalvelli/nixos_config/issues/new) with details

### External Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/) - Official NixOS documentation
- [Home Manager Manual](https://nix-community.github.io/home-manager/) - User environment management
- [Nix Pills](https://nixos.org/guides/nix-pills/) - Deep dive into Nix
- [NixOS Wiki](https://wiki.nixos.org/) - Community knowledge base

## Contributing to Documentation

When updating documentation:

- **Keep it clear**: Use simple, direct language
- **Keep it concise**: Get to the point quickly
- **Keep it complete**: Include examples and troubleshooting
- **Keep it current**: Update when features change
- **Test instructions**: Verify commands and procedures work

## Quick Links

- 📖 **Main README**: [../README.md](../README.md)
- 💾 **Repository**: https://github.com/kcalvelli/nixos_config
- 🚀 **Releases**: https://github.com/kcalvelli/nixos_config/releases
- 🐛 **Issues**: https://github.com/kcalvelli/nixos_config/issues

---

**Last Updated**: October 2025
