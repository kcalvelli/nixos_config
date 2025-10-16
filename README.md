# axiOS

<p align="center">
  <img src="docs/logo.png" alt="axiOS Logo" width="400">
</p>

<p align="center">
  <em>A personal <a href="https://nixos.org">NixOS</a> configuration built with flakes, featuring modular system configurations, <a href="https://github.com/nix-community/home-manager">Home Manager</a> integration, and curated development environments.</em>
</p>

## ⚠️ Usage Warning

**This configuration is intended for inspiration and reference only.** It is not a production-ready framework or a batteries-included NixOS distribution. It is highly opinionated, designed for specific hardware, and tailored to my personal workflow preferences.

**Do not blindly copy or deploy this configuration.** It may contain hardware-specific settings, undocumented assumptions, and configurations that could break your system. Use it to learn and cherry-pick ideas, not as a drop-in solution.

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
│   └── PACKAGES.md    # Package organization guide
├── hosts/              # Per-machine configurations
│   ├── edge/          # Host-specific settings
│   └── pangolin/      # Host-specific settings
├── modules/            # Reusable NixOS modules (system-level)
│   ├── desktop/       # Desktop environment and compositor configs
│   ├── development/   # Development tools and IDEs
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
│   └── profiles/      # Machine-type profiles (workstation, laptop)
├── devshells/         # Development environment definitions
└── pkgs/              # Custom package definitions (auto-discovered)
```

**Note:** Each major module directory contains a `README.md` explaining its purpose and package organization. See [`docs/PACKAGES.md`](docs/PACKAGES.md) for the complete package organization guide.

### Module Documentation

**System Modules** (`modules/`):
- [`system/`](modules/system/README.md) - Core system utilities and base configuration
- [`desktop/`](modules/desktop/README.md) - Desktop environments and shared services
- [`development/`](modules/development/README.md) - Development tools and services
- [`gaming/`](modules/gaming/README.md) - Gaming infrastructure (Steam, GameMode)
- [`graphics/`](modules/graphics/README.md) - GPU configuration and tools
- [`virtualisation/`](modules/virtualisation/README.md) - Containers and VMs

**Home Manager Modules** (`home/`):
- [`common/`](home/common/README.md) - Shared user applications and configs
- [`desktops/wayland/`](home/desktops/wayland/README.md) - Wayland-specific user tools
- [`profiles/`](home/profiles/README.md) - Machine-type profiles (workstation/laptop)

**Central Documentation**:
- [`docs/PACKAGES.md`](docs/PACKAGES.md) - Complete package organization guide
- [`docs/NIRI_WALLPAPER.md`](docs/NIRI_WALLPAPER.md) - Niri wallpaper blur setup with DankMaterialShell

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
- **Secure boot** implementation via Lanzaboote
- **Containerization** support with Podman
- **Virtualization** with quickemu/quickgui
- **Hardware-specific optimizations** for System76 and MSI hardware

## Getting Started

### Exploring the Configuration

If you want to explore this configuration:

1. **Start with documentation**:
   - Read [`docs/PACKAGES.md`](docs/PACKAGES.md) to understand the package organization philosophy
   - Browse module `README.md` files to see what each module provides
   
2. **Understand the structure**:
   - Read `flake.nix` to see how inputs and outputs are defined
   - Browse `modules/` to see system-level configurations
   - Browse `home/` to see user-level configurations
   
3. **Learn from patterns**:
   - See how `packages.nix` files organize packages by category
   - Notice the `=== Section Headers ===` used throughout for navigation
   - Observe the system vs. home-manager split decisions

To adapt portions for your own use, extract only the specific modules or patterns you need, understand what they do, and modify them for your hardware and preferences. Never apply this configuration directly to your system without thorough review and customization.

### Adding Custom Packages

Custom packages are automatically discovered from the `pkgs/` directory. To add a new package:

1. Create a new directory in `pkgs/` (e.g., `pkgs/my-package/`)
2. Add a `default.nix` file in that directory with your package definition
3. The package will be automatically added to flake outputs and available as `pkgs.my-package`

No manual registration needed - the build system scans for all directories containing `default.nix` and adds them automatically.

### Package Organization

This configuration uses a **modular, well-documented approach** to package management with deliberate separation between system-level and user-level packages.

#### Key Organization Features

**Categorized Package Lists:**
Each major module contains a `packages.nix` file with packages organized by logical categories:
```nix
# Example: modules/system/packages.nix
{ pkgs }: {
  core = with pkgs; [ curl wget killall ];
  filesystem = with pkgs; [ sshfs fuse ntfs3g ];
  monitoring = with pkgs; [ htop gtop lm_sensors ];
  # ... more categories
}
```

**Clear Section Headers:**
All configuration files use section comments for easy navigation:
```nix
# === System Packages ===
# === Development Services ===
# === Desktop Applications ===
```

**Module Documentation:**
Every major module directory includes a `README.md` explaining:
- What packages belong in that module
- How packages are organized
- Where alternatives should go
- Configuration examples

#### Quick Reference

| Package Type | Location | Example |
|--------------|----------|---------|
| Core utilities | `modules/system/packages.nix` | curl, wget, htop |
| Development tools | `modules/development/packages.nix` | vscode, nil, gh |
| GPU tools | `modules/graphics/packages.nix` | corectrl, radeontop |
| Desktop apps | `home/common/packages.nix` | obsidian, discord, libreoffice |
| Wayland tools | `home/desktops/wayland/packages.nix` | fuzzel, grim, waybar |

#### Decision Guide

**Install at system level** (`modules/`) if the package:
- Requires privileged access or runs as a service
- Needs hardware access (GPU, peripherals)
- Must be available to root or multiple users
- Requires firewall rules or system networking

**Install with home-manager** (`home/`) if the package:
- Is a user desktop application
- Has user-specific configuration/dotfiles
- Is a personal productivity tool or preference

#### Documentation

For comprehensive guidance on adding packages:
- **[`docs/PACKAGES.md`](docs/PACKAGES.md)** - Complete guide with decision trees, examples, and patterns
- Individual module `README.md` files in `modules/` and `home/` directories for module-specific information

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

### Adding a New User

1. **Create a user file**: `modules/users/[username].nix`
2. **Use the template** from [`modules/users/README.md`](modules/users/README.md)
3. **Customize** the username, full name, email, and groups
4. **Rebuild**: `sudo nixos-rebuild switch --flake .`

Example user file:
```nix
{ self, config, ... }:
let
  username = "alice";
  fullName = "Alice Smith";
  email = "alice@example.com";
  homeDir = "/home/${username}";
in
{
  users.users.${username} = {
    isNormalUser = true;
    description = fullName;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager.users.${username} = {
    home = {
      stateVersion = "24.05";
      homeDirectory = homeDir;
      username = username;
    };
    programs.git = {
      userName = fullName;
      userEmail = email;
    };
  };
}
```

**No manual imports needed!** The system automatically discovers all `.nix` files in `modules/users/` (except `default.nix`).

### What Goes in User Files

**Include in user files:**
- Username, full name, email
- System groups and permissions
- User-specific paths (home directory, backgrounds, shares)
- User-specific git config
- Trusted user settings

**Keep in shared home-manager config:**
- Application configurations
- Desktop environment settings
- Package lists
- Shell configurations

See [`modules/users/keith.nix`](modules/users/keith.nix) for a complete example and [`modules/users/README.md`](modules/users/README.md) for detailed documentation.

## Acknowledgments

This configuration has been assembled over time drawing inspiration from countless [NixOS](https://nixos.org) configurations, blog posts, and community examples. Special thanks to the nix-community projects ([Home Manager](https://github.com/nix-community/home-manager), devshell), the [Niri](https://github.com/YaLTeR/niri) compositor project, [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell), and the broader NixOS ecosystem for making declarative system configuration possible.

## License

MIT License. Use at your own risk. No support provided.
