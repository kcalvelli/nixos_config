
# nixos_config

This repository contains a modular, flake-based NixOS configuration for multiple hosts and user environments. It is designed for flexibility, reproducibility, and ease of customization, supporting both desktop and workstation setups.

## Features

- **Flake-based**: Uses Nix flakes for reliable and reproducible builds.
- **Host-specific configs**: Each machine (e.g., `edge`, `pangolin`) has its own configuration under `hosts/`.
- **Modular system**: System, hardware, networking, services, and user modules are organized under `modules/` for easy reuse and extension.
- **Home Manager integration**: User environments are managed with Home Manager modules in `home/`.
- **Desktop Environments**: Supports KDE Plasma 6 (see `modules/desktop/plasma.nix`) and Cosmic.
- **Custom Packages**: Local package definitions in `pkgs/` for software not available in upstream Nixpkgs or with custom patches.
- **Gaming, security, and development modules**: Easily enable/disable features per host or user.
- **Wayland and SDDM**: Modern display stack with Wayland and SDDM support.
- **Flatpak and AppImage**: Optional support for additional app sources.

## Directory Structure

- `flake.nix`, `flake.lock` — Flake entrypoints
- `hosts/` — Per-host system configurations
- `modules/` — Modular NixOS and Home Manager modules
- `home/` — Home Manager user environment modules and resources
- `pkgs/` — Custom and third-party package definitions
- `README.md` — This file

## Usage Notice

**This repository is highly customized for my personal NixOS systems and is not intended to be used directly on other machines.**

If you are interested in building your own NixOS configuration, you may use this repository as a reference for structure, modularization, and flake-based workflows. Please review the modules and package definitions to adapt them to your own needs and hardware. Many settings, packages, and modules are tailored specifically for my workflow and hardware, and may not be suitable for general use without significant modification.

## Adding/Updating Packages

- Add new packages to `pkgs/` as needed. Use overlays or callPackage as appropriate.
- For custom or third-party software, update the `sha256` after the first build as prompted by Nix.

## Notable Modules

- `modules/desktop/plasma.nix`: KDE Plasma 6 desktop configuration, including SDDM, Flatpak, and curated KDE apps.
- `home/terminal.nix`: Unified terminal, shell, and prompt configuration (Vim, Fish, Starship, Ghostty, etc).
- `pkgs/`: Custom package definitions, including some Qt-based software and other utilities.

## License

This repository is licensed under the MIT License. See `LICENSE` for details.
