# axiOS

<p align="center">
  <img src="docs/logo.png" alt="axiOS Logo" width="400">
</p>

<p align="center">
  <em>A personal <a href="https://nixos.org">NixOS</a> configuration built with flakes, featuring modular system configurations, <a href="https://github.com/nix-community/home-manager">Home Manager</a> integration, and curated development environments.</em>
</p>

## ⚠️ Usage Warning

**This is a personal NixOS configuration** built for specific hardware and workflows. While it includes an automated installer for convenience, it is highly opinionated and tailored to my preferences.

**For new users:** The automated installer makes it easy to try axiOS, but you should understand what you're installing. Review the configuration, especially hardware-specific settings in `hosts/`, before deploying to production systems.

**For learning:** This configuration is excellent for learning NixOS patterns, modular architecture, and modern tooling. Feel free to explore, cherry-pick ideas, and adapt components for your own configuration.

**Recommendation:** Use the installer to test in a VM first, then customize the generated host configuration to match your hardware and preferences before deploying to bare metal.

## What is axiOS?

axiOS is a declarative system configuration leveraging [NixOS](https://nixos.org) flakes to manage multiple machines with shared modules and per-host customization. It integrates modern tools and desktop environments including the [Niri](https://github.com/YaLTeR/niri) scrollable tiling compositor, Ghostty terminal, and extensive development tooling for various programming languages.

The configuration emphasizes reproducibility through Nix flakes while maintaining flexibility for experimentation. It includes:

- **Modular architecture** with reusable components organized by function (desktop, development, gaming, networking, services, etc.)
- **Organized package management** with categorized package lists and comprehensive documentation
- **[Home Manager](https://github.com/nix-community/home-manager) integration** for declarative user environment management
- **Development shells** with pre-configured toolchains for multiple languages and frameworks
- **Secure boot support** via Lanzaboote
- **Modern desktop environments** with [Niri](https://github.com/YaLTeR/niri) compositor and custom shell configurations
- **Self-documenting modules** with README files explaining purpose and organization

## Screenshots

### Niri Overview
![Niri Overview](docs/screenshots/overview.png)
*[Niri](https://github.com/YaLTeR/niri) scrollable tiling compositor with workspace overview*

### Dropdown Terminal
![Dropdown Terminal](docs/screenshots/dropdown.png)
*Ghostty terminal with dropdown mode and custom theming*

### File Manager
![Nautilus File Manager](docs/screenshots/nautilus.png)
*Nautilus file manager with custom theme integration*

## Structure

```
.
├── flake.nix           # Flake entrypoint and input definitions
├── flake.lock          # Locked dependency versions
├── docs/               # Documentation
│   ├── INSTALLATION.md         # Installation guide
│   ├── BUILDING_ISO.md         # ISO build guide
│   ├── QUICK_REFERENCE.md      # Quick reference
│   ├── PACKAGES.md             # Package organization guide
│   ├── ADDING_HOSTS.md         # Host management guide
│   ├── NIRI_WALLPAPER.md       # Niri wallpaper setup
│   └── screenshots/            # Desktop screenshots
├── scripts/            # Automation scripts
│   └── install-axios.sh        # Automated installer
├── hosts/              # Per-machine configurations
│   ├── edge/                   # Desktop host
│   ├── pangolin/               # Laptop host
│   ├── installer/              # Installer ISO config
│   └── profiles/               # Host type profiles
├── modules/            # Reusable NixOS modules (system-level)
│   ├── desktop/       # Desktop environment and compositor configs
│   ├── development/   # Development tools and IDEs
│   ├── disko/         # Declarative disk management templates
│   ├── gaming/        # Gaming platform integrations
│   ├── graphics/      # Graphics drivers and tools
│   ├── hardware/      # Hardware-specific configurations
│   ├── networking/    # Network services and VPNs
│   ├── services/      # System services
│   ├── system/        # Core system settings
│   ├── users/         # User account definitions
│   └── virtualisation/ # VM and container support
├── home/              # Home Manager user configurations (user-level)
│   ├── common/        # Shared user configs
│   ├── desktops/      # Desktop-specific user configs
│   ├── profiles/      # Machine-type profiles (workstation, laptop)
│   └── resources/     # Shared resources (themes, etc.)
├── devshells/         # Development environment definitions
└── pkgs/              # Custom package definitions (auto-discovered)
```

**Note:** Each major module directory contains a `README.md` explaining its purpose and package organization. See [`docs/PACKAGES.md`](docs/PACKAGES.md) for the complete package organization guide and module documentation links.

## Key Features

### Desktop Experience
- **[Niri compositor](https://github.com/YaLTeR/niri)** with [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) integration for a modern tiling workflow
- **Wallpaper blur effects** for overview mode using WallpaperWatcherDaemon (see [`docs/NIRI_WALLPAPER.md`](docs/NIRI_WALLPAPER.md))
- **Ghostty** terminal emulator built from source
- **LazyVim** Neovim distribution with LSP support
- **Hardware acceleration** with proper AMD graphics driver integration
- Gaming support with Steam, GameMode, and Gamescope

### Package Management
- **Organized package structure** with categorized `packages.nix` files in each module
- **Clear documentation** with README files explaining what goes where
- **System/Home-Manager split** with explicit guidelines for package placement
- **Section comments** throughout configuration files for easy navigation
- **Declarative and reproducible** with flake-based package management

### Development
- **Multi-language dev environments** including Rust (via Fenix), Zig, Python, Node.js, and more
- **Development tools** organized by category with clear module boundaries
- **DevShells** for project-specific toolchains

### Infrastructure
- **Declarative disk management** with disko templates for automated provisioning
- **Secure boot** implementation via Lanzaboote
- **Containerization** support with Podman
- **Virtualization** with quickemu/quickgui
- **Hardware-specific optimizations** for System76 and MSI hardware

## Quick Installation

### Option 1: Automated Installer (Recommended)

Download the axiOS installer ISO and use the automated installation script:

1. **Download ISO** from [GitHub Releases](https://github.com/kcalvelli/nixos_config/releases/latest)
2. **Create bootable USB** and boot from it
3. **Run installer**: `/root/install`
4. **Follow prompts** to configure your system
5. **Reboot** and enjoy!

See [`docs/INSTALLATION.md`](docs/INSTALLATION.md) for detailed installation instructions.

### Option 2: Manual Installation

For more control, use the standard NixOS installer:

1. Boot NixOS installer ISO
2. Clone this repository: `git clone https://github.com/kcalvelli/nixos_config`
3. Run installer script: `sudo ./scripts/install-axios.sh`

Or follow manual steps in [`docs/INSTALLATION.md`](docs/INSTALLATION.md).

### Building Custom ISO

Build your own installer ISO:

```bash
nix build .#iso
# Output: result/iso/axios-installer-x86_64-linux.iso
```

See [`docs/BUILDING_ISO.md`](docs/BUILDING_ISO.md) for customization options.

## Getting Started

### First Time Installation

The automated installer makes it easy to get started. It will:
- Detect your hardware (CPU, GPU, laptop/desktop)
- Help you partition disks safely
- Install a configured NixOS system
- Generate host configuration for future customization

**Recommended approach:**
1. Test in a VM first to understand the system
2. Review the generated configuration
3. Customize for your needs before production deployment

See the documentation to understand the architecture, then use the installer or adapt components for your setup.

Key documentation to explore:
- [`docs/INSTALLATION.md`](docs/INSTALLATION.md) - Installation guide with automated installer
- [`docs/BUILDING_ISO.md`](docs/BUILDING_ISO.md) - Build custom installer ISO
- [`docs/PACKAGES.md`](docs/PACKAGES.md) - Package organization philosophy and decision trees
- [`modules/disko/README.md`](modules/disko/README.md) - Declarative disk configuration
- Module `README.md` files throughout `modules/` and `home/` - Purpose and contents of each module
- [`docs/NIRI_WALLPAPER.md`](docs/NIRI_WALLPAPER.md) - Niri wallpaper blur setup guide

### Adding Custom Packages

Custom packages are automatically discovered from the `pkgs/` directory:

1. Create a new directory in `pkgs/` (e.g., `pkgs/my-package/`)
2. Add a `default.nix` file with your package definition
3. The package will be automatically available as `pkgs.my-package`

For adding packages from nixpkgs, see [`docs/PACKAGES.md`](docs/PACKAGES.md) for guidance on system vs. home-manager placement and module organization.

## Dependencies

This flake pulls in numerous external projects including nixpkgs-unstable, Home Manager, various development overlays, and custom packages. Check `flake.nix` for the complete input list and their upstream sources.

## Development

Development shells are available for various tech stacks. Use `nix develop` to enter a configured environment with language-specific tooling pre-installed.

Available shells:
- **Spec** (default) - GitHub Spec Kit for Spec-Driven Development methodology
- **Rust** - Fenix toolchain with rust-analyzer and cargo-watch
- **Zig** - Latest Zig compiler with ZLS language server
- **QML** - Qt6/QML development for Quickshell and QML applications

Enter a specific shell with `nix develop .#<name>`, for example:
```bash
nix develop .#rust  # Rust development
nix develop .#qml   # QML/Quickshell development
```

Each shell includes an info command (e.g., `rust-info`, `qml-info`) to display available commands and toolchain versions.

Development packages are organized in `modules/development/packages.nix` by category (editors, nix tools, shell utilities, version control, AI tools).

## User Management

This configuration uses an **auto-discovery system** for user management. Simply drop a new user file in `modules/users/` and it will be automatically imported.

See **[`modules/users/README.md`](modules/users/README.md)** for the complete user template and detailed documentation on what goes in user files versus shared home-manager configuration.

## Acknowledgments

This configuration has been assembled over time drawing inspiration from countless [NixOS](https://nixos.org) configurations, blog posts, and community examples. Special thanks to the nix-community projects ([Home Manager](https://github.com/nix-community/home-manager), devshell), the [Niri](https://github.com/YaLTeR/niri) compositor project, [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell), and the broader NixOS ecosystem for making declarative system configuration possible.

## License

MIT License. Use at your own risk. No support provided.
