# AxiOS

A personal [NixOS](https://nixos.org) configuration built with flakes, featuring modular system configurations, Home Manager integration, and curated development environments.

## ⚠️ Usage Warning

**This configuration is intended for inspiration and reference only.** It is not a production-ready framework or a batteries-included NixOS distribution. It is highly opinionated, designed for specific hardware, and tailored to my personal workflow preferences.

**Do not blindly copy or deploy this configuration.** It may contain hardware-specific settings, undocumented assumptions, and configurations that could break your system. Use it to learn and cherry-pick ideas, not as a drop-in solution.

## What is AxiOS?

AxiOS is a declarative system configuration leveraging NixOS flakes to manage multiple machines with shared modules and per-host customization. It integrates modern tools and desktop environments including the Niri scrollable tiling compositor, Ghostty terminal, and extensive development tooling for various programming languages.

The configuration emphasizes reproducibility through Nix flakes while maintaining flexibility for experimentation. It includes:

- **Modular architecture** with reusable components organized by function (desktop, development, gaming, networking, services, etc.)
- **Home Manager integration** for declarative user environment management
- **Development shells** with pre-configured toolchains for multiple languages and frameworks
- **Secure boot support** via Lanzaboote
- **Modern desktop environments** with Niri compositor and custom shell configurations

## Structure

```
.
├── flake.nix           # Flake entrypoint and input definitions
├── flake.lock          # Locked dependency versions
├── hosts/              # Per-machine configurations
│   ├── edge/          # Host-specific settings
│   └── pangolin/      # Host-specific settings
├── modules/            # Reusable NixOS modules
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
├── home/              # Home Manager user configurations
├── devshells/         # Development environment definitions
└── pkgs/              # Custom package definitions
```

## Key Features

- **Niri compositor** with DankMaterialShell integration for a modern tiling workflow
- **Ghostty** terminal emulator built from source
- **LazyVim** Neovim distribution with LSP support
- **Multi-language dev environments** including Rust (via Fenix), Zig, Python, Node.js, and more
- **Hardware acceleration** with proper graphics driver integration
- **Secure boot** implementation via Lanzaboote
- **Declarative package management** with flake-based reproducibility

## Getting Started

If you want to explore this configuration, start by reading `flake.nix` to understand the input structure and see how modules are composed. Then browse through `modules/` to see how different system aspects are configured.

To adapt portions for your own use, extract only the specific modules or patterns you need, understand what they do, and modify them for your hardware and preferences. Never apply this configuration directly to your system without thorough review and customization.

## Dependencies

This flake pulls in numerous external projects including nixpkgs-unstable, Home Manager, various development overlays, and custom packages. Check `flake.nix` for the complete input list and their upstream sources.

## Development

Development shells are available for various tech stacks. Use `nix develop` to enter a configured environment with language-specific tooling pre-installed.

## Acknowledgments

This configuration has been assembled over time drawing inspiration from countless NixOS configurations, blog posts, and community examples. Special thanks to the nix-community projects (Home Manager, devshell), and the broader NixOS ecosystem for making declarative system configuration possible.

## License

MIT License. Use at your own risk. No support provided.
