# Documentation Index

Welcome to the NixOS configuration documentation!

## Getting Started

- **[Adding Hosts](ADDING_HOSTS.md)** - Guide for adding new hosts to the configuration

## System Management

### Filesystem Snapshots

- **[Btrfs Snapshots Guide](BTRFS_SNAPSHOTS_GUIDE.md)** - Optional guide for implementing btrfs with automatic snapshots for easy system rollback

## Desktop Environments

- **[Niri Wallpaper Setup](NIRI_WALLPAPER.md)** - WallpaperWatcherDaemon configuration

## Architecture

### Current Structure

```
nixos_config/
├── hosts/           # Host configurations
│   ├── README.md    # Host management guide
│   ├── edge.nix     # Desktop workstation config
│   └── pangolin.nix # Laptop config
├── modules/         # NixOS modules
│   ├── system/      # Core system
│   ├── desktop/     # Desktop environments
│   ├── hardware/    # Hardware-specific
│   ├── services/    # System services
│   └── ...
├── home/            # Home-manager configs
│   ├── common/      # Shared configs
│   ├── profiles/    # User profiles
│   └── desktops/    # Desktop-specific
└── docs/            # Documentation (you are here)
```

## Quick Links

### Configuration Guides
- [Adding Hosts](ADDING_HOSTS.md)
- [Btrfs Snapshots](BTRFS_SNAPSHOTS_GUIDE.md) - Optional advanced feature

### Desktop Setup
- [Niri Wallpaper](NIRI_WALLPAPER.md)

### Reference
- [Host Templates](../hosts/TEMPLATE.nix)
- [Disko Templates](../modules/disko/templates/)

## Contributing

When adding documentation:

1. Create a new `.md` file in this directory
2. Add it to this index
3. Link from relevant configuration files
4. Keep it concise and actionable

## External Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [NixOS Wiki](https://wiki.nixos.org/)

---

**Last Updated**: 2025-10-17
