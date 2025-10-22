# axiOS

<p align="center">
  <img src="docs/logo.png" alt="axiOS Logo" width="400">
</p>

<p align="center">
  <em>A modular <a href="https://nixos.org">NixOS</a> distribution built with flakes, featuring flexible system configurations, <a href="https://github.com/nix-community/home-manager">Home Manager</a> integration, and curated development environments.</em>
</p>

## Overview

axiOS is a complete NixOS distribution ready for deployment on your hardware. It provides a modern, declarative system configuration leveraging [NixOS](https://nixos.org) flakes to manage systems with shared modules and per-host customization.

**This is a distribution, not a personal configuration.** It's designed to be cloned, customized, and deployed on your own systems. All personal configurations have been removed, making it a clean starting point for building your own NixOS setup.

The configuration emphasizes reproducibility through Nix flakes while maintaining flexibility for customization. It includes:

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
├── flake.nix           # Flake entrypoint and inputs
├── flake.lock          # Locked dependency versions
├── docs/               # Documentation
│   ├── INSTALLATION.md         # Complete installation guide
│   ├── BUILDING_ISO.md         # ISO build instructions
│   ├── QUICK_REFERENCE.md      # Command reference
│   ├── PACKAGES.md             # Package organization
│   ├── ADDING_HOSTS.md         # Multi-machine management
│   └── NIRI_WALLPAPER.md       # Desktop customization
├── scripts/            # Automation scripts
│   ├── shell/                  # Shell scripts
│   │   ├── install-axios.sh    # Automated installer
│   │   ├── add-host.sh         # Create new host config
│   │   ├── add-user.sh         # Create new user
│   │   ├── burn-iso.sh         # Create bootable USB
│   │   ├── wallpaper-blur.sh   # Wallpaper blur generation
│   │   └── update-material-code-theme.sh
│   ├── nix/                    # Nix integration modules
│   │   ├── installer.nix       # ISO installer config
│   │   └── wallpaper-scripts.nix
│   └── README.md               # Scripts documentation
├── hosts/              # Per-machine configurations
│   ├── edge/                   # Desktop host
│   ├── pangolin/               # Laptop host
│   ├── TEMPLATE.nix            # Host template
│   └── installer/              # Installer ISO config
├── modules/            # Reusable NixOS modules (system-level)
│   ├── desktop/       # Desktop environment configs
│   ├── development/   # Development tools and IDEs
│   ├── disko/         # Disk management templates
│   ├── gaming/        # Gaming platform support
│   ├── graphics/      # Graphics drivers
│   ├── hardware/      # Hardware-specific configs (desktop/laptop)
│   ├── networking/    # Network services and VPNs
│   ├── services/      # System services
│   ├── system/        # Core system settings
│   ├── users/         # User account definitions
│   └── virtualisation/ # VM and container support
├── home/              # Home Manager user configs (user-level)
│   ├── common/        # Shared user configurations
│   ├── desktops/      # Desktop-specific configs (Wayland/Niri)
│   ├── profiles/      # User profiles (workstation, laptop)
│   └── resources/     # Shared resources (themes, fonts)
├── devshells/         # Development environment definitions
└── pkgs/              # Custom package definitions (auto-discovered)
```

**Note:** Each major module directory contains a `README.md` explaining its purpose and organization. See [`docs/PACKAGES.md`](docs/PACKAGES.md) for the complete package organization guide.

## Key Features

### Desktop Experience
- **[Niri compositor](https://github.com/YaLTeR/niri)** - Scrollable tiling Wayland compositor
- **DankMaterialShell integration** - Material design shell for Niri
- **Wallpaper blur effects** - Automatic blur for overview mode (see [`docs/NIRI_WALLPAPER.md`](docs/NIRI_WALLPAPER.md))
- **Ghostty terminal** - Modern GPU-accelerated terminal emulator
- **LazyVim** - Pre-configured Neovim with LSP support
- **Hardware acceleration** - Optimized AMD/Intel graphics drivers
- **Gaming support** - Steam, GameMode, and Gamescope integration

### Package Management
- **Organized structure** - Categorized `packages.nix` files in each module
- **Clear documentation** - README files explain package placement
- **System/Home split** - Explicit guidelines for package organization
- **Section comments** - Easy navigation throughout configs
- **Declarative & reproducible** - Flake-based package management

### Development
- **Multi-language environments** - Rust (Fenix), Zig, Python, Node.js, and more
- **Development tools** - Organized by category with clear module boundaries
- **DevShells** - Project-specific toolchains via `nix develop`
- **LSP support** - Language servers for major languages

### Infrastructure
- **Declarative disks** - Disko templates for automated disk provisioning
- **Secure boot** - Optional Lanzaboote implementation
- **Containerization** - Podman support for containers
- **Virtualization** - QEMU and VM management tools
- **Hardware optimization** - Automatic desktop/laptop configuration

## Quick Installation

### Automated Installation (Recommended)

1. **Download ISO** from [GitHub Releases](https://github.com/kcalvelli/axios/releases/latest)
2. **Create bootable USB** and boot your system
3. **Run installer**: Type `/root/install` or just `install`
4. **Follow prompts** to configure:
   - Hardware detection (CPU, GPU, laptop/desktop)
   - Disk layout (standard/encrypted/btrfs)
   - Hostname and user account
   - Feature selection (desktop/gaming/dev tools)
   - Password setup
5. **Reboot** into your new system
6. **Optional**: Configure Secure Boot (see installation docs)

The installer creates an **independent copy** of the configuration in `/etc/nixos`. You have full control to manage and customize your configuration however you prefer.

See [`docs/INSTALLATION.md`](docs/INSTALLATION.md) for detailed instructions and options.

### Manual Installation

For more control over the installation process:

1. Boot NixOS installer ISO (official or axiOS)
2. Clone repository: `git clone https://github.com/kcalvelli/axios`
3. Run installer: `sudo ./axios/scripts/shell/install-axios.sh`
4. Or follow manual steps in [`docs/INSTALLATION.md`](docs/INSTALLATION.md)

### Building Custom ISO

Build your own installer ISO with customizations:

```bash
nix build .#iso
# Output: result/iso/axios-installer-x86_64-linux.iso
```

See [`docs/BUILDING_ISO.md`](docs/BUILDING_ISO.md) for customization options and CI/CD integration.

## Getting Started

### After Installation

The automated installer creates an independent configuration in `/etc/nixos` that you fully control:

- ✅ Independent git repository ready for your customizations
- ✅ No ties to upstream - manage updates on your terms
- ✅ Full control over your configuration
- ✅ Optional: Push to your own GitHub/GitLab repository
- ✅ Optional: Pull upstream changes when you want new features

**First steps after installation:**

1. **Verify installation**: Check system info and functionality
2. **Add your user**: Use the included user template or script
3. **Configure your host**: Edit your host config in `/etc/nixos/hosts/`
4. **Customize**: Review module READMEs to understand the structure
5. **Update**: Learn to manage flake updates and rebuilds

### Essential Documentation

Start with these guides to get productive quickly:

- [`docs/INSTALLATION.md`](docs/INSTALLATION.md) - Complete installation guide
- [`docs/PACKAGES.md`](docs/PACKAGES.md) - Package organization and best practices
- [`docs/QUICK_REFERENCE.md`](docs/QUICK_REFERENCE.md) - Common commands
- Module `README.md` files in `modules/` and `home/` - Detailed module docs
- [`docs/NIRI_WALLPAPER.md`](docs/NIRI_WALLPAPER.md) - Desktop customization

### Adding Custom Packages

Custom packages are auto-discovered from `pkgs/`:

1. Create directory: `pkgs/my-package/`
2. Add `default.nix` with package definition
3. Package available as `pkgs.my-package`

For nixpkgs packages, see [`docs/PACKAGES.md`](docs/PACKAGES.md) for placement guidelines.

## Development Environments

Development shells provide pre-configured toolchains. Use `nix develop` to enter an environment:

**Available shells:**
- **Spec** (default) - GitHub Spec Kit for Spec-Driven Development
- **Rust** - Fenix toolchain with rust-analyzer and cargo-watch
- **Zig** - Zig compiler with ZLS language server
- **QML** - Qt6/QML for Quickshell and QML applications

```bash
# Enter default shell
nix develop

# Enter specific shell
nix develop .#rust
nix develop .#zig
nix develop .#qml
```

Each shell includes an info command (e.g., `rust-info`) to display available tools and versions.

## User Management

This configuration uses **auto-discovery** for user accounts. Add a new user by creating a file in `modules/users/`:

```bash
# Use the helper script
./scripts/shell/add-user.sh

# Or manually create modules/users/username.nix
```

See [`modules/users/README.md`](modules/users/README.md) for the complete user template and documentation.

**Note**: You'll need to create at least one user account. The distribution ships without any pre-configured users.

## Acknowledgments

This configuration has been assembled over time drawing inspiration from countless [NixOS](https://nixos.org) configurations, blog posts, and community examples. Special thanks to the nix-community projects ([Home Manager](https://github.com/nix-community/home-manager), devshell), the [Niri](https://github.com/YaLTeR/niri) compositor project, [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell), and the broader NixOS ecosystem for making declarative system configuration possible.

## License

MIT License. Use at your own risk. No support provided.
