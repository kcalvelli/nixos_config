# axiOS Documentation

This directory contains comprehensive documentation for the axiOS NixOS configuration.

## Installation & Setup

### 📦 [INSTALLATION.md](INSTALLATION.md)
Complete guide to installing axiOS using the automated installer.

- Download ISO or use standard NixOS installer
- Create bootable USB
- Run automated installer
- Post-installation configuration
- Troubleshooting common issues

**Start here if you want to install axiOS.**

### 🔨 [BUILDING_ISO.md](BUILDING_ISO.md)
Guide for building and customizing the axiOS installer ISO.

- Build the ISO from source
- Customize packages and branding
- Test in QEMU/VMs
- CI/CD integration
- Distribution strategies

**For developers who want to build or customize the installer.**

### ⚡ [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
Quick command reference for common tasks.

- Build ISO
- Test in VM
- Customize installer
- Troubleshooting quick fixes
- Common operations

**For quick lookups without reading full documentation.**

## Configuration & Organization

### 📚 [PACKAGES.md](PACKAGES.md)
Package organization philosophy and guidelines.

- Where to put packages (system vs home-manager)
- Module organization
- Decision trees for package placement
- Best practices

**Read this before adding new packages to the configuration.**

### 🖥️ [ADDING_HOSTS.md](ADDING_HOSTS.md)
Guide for adding new machines to the configuration.

- Different approaches to host management
- Current implementation details
- Host configuration templates
- Comparison of methods

**For managing multiple machines with this configuration.**

### 🎨 [NIRI_WALLPAPER.md](NIRI_WALLPAPER.md)
Setup guide for Niri wallpaper blur effects.

- WallpaperWatcherDaemon setup
- Overview mode blur configuration
- Troubleshooting

**For desktop customization with Niri compositor.**

## Screenshots

Visual examples of the axiOS desktop environment:

- `screenshots/overview.png` - Niri workspace overview
- `screenshots/dropdown.png` - Ghostty dropdown terminal
- `screenshots/nautilus.png` - Nautilus file manager

## Documentation Index

| Document | Purpose | Audience |
|----------|---------|----------|
| [INSTALLATION.md](INSTALLATION.md) | Install axiOS | End Users |
| [BUILDING_ISO.md](BUILDING_ISO.md) | Build custom ISO | Developers |
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md) | Quick commands | Everyone |
| [PACKAGES.md](PACKAGES.md) | Package organization | Contributors |
| [ADDING_HOSTS.md](ADDING_HOSTS.md) | Manage hosts | Power Users |
| [NIRI_WALLPAPER.md](NIRI_WALLPAPER.md) | Desktop customization | Desktop Users |

## Quick Links

- **Main README**: [../README.md](../README.md)
- **Repository**: https://github.com/kcalvelli/nixos_config
- **Releases**: https://github.com/kcalvelli/nixos_config/releases
- **Issues**: https://github.com/kcalvelli/nixos_config/issues

## Configuration Structure

```
nixos_config/
├── hosts/              # Host configurations
│   ├── edge.nix       # Desktop workstation
│   ├── pangolin.nix   # Laptop
│   ├── installer/     # Installer ISO config
│   └── profiles/      # Host type profiles
├── modules/            # NixOS modules
│   ├── system/        # Core system
│   ├── desktop/       # Desktop environments
│   ├── disko/         # Disk management
│   ├── hardware/      # Hardware-specific
│   ├── services/      # System services
│   └── ...
├── home/               # Home-manager configs
│   ├── common/        # Shared configs
│   ├── profiles/      # User profiles
│   └── desktops/      # Desktop-specific
├── scripts/            # Automation scripts
│   └── install-axios.sh  # Automated installer
└── docs/               # Documentation (you are here)
```

## Contributing

When adding new features or making significant changes, please update the relevant documentation. Keep documentation:

- **Clear**: Use simple language
- **Concise**: Get to the point quickly
- **Complete**: Include examples and troubleshooting
- **Current**: Update when features change

## Getting Help

1. Check the relevant documentation above
2. Search existing [GitHub Issues](https://github.com/kcalvelli/nixos_config/issues)
3. Ask on [NixOS Discourse](https://discourse.nixos.org/)
4. Create a new issue with details about your problem

## External Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [NixOS Wiki](https://wiki.nixos.org/)

---

**Last Updated**: 2025-10-17
