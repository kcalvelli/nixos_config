# Personal NixOS Configuration

This repository contains my personal NixOS configuration files. It's a highly customized setup tailored for my specific needs and preferences.

## Overview

This NixOS configuration sets up a system with:

- COSMIC desktop environment
- Hardware-specific optimizations for AMD CPUs and GPUs
- Custom packages and overlays

## Directory Structure

- `flake.nix`: The entry point for the Nix configuration
- `hosts/`: Contains host-specific configurations
- `modules/`: Modular NixOS configurations
  - `desktop/`: Desktop environment settings
  - `development/`: Development tools and settings
  - `hardware/`: Hardware-specific settings
  - `networking/`: Network configurations
  - `services/`: Various system services
  - `system/`: Core system configurations
  - `users/`: User-specific settings
- `home/`: Home-manager configurations
- `pkgs/`: Custom package definitions

## Installation

1. Install NixOS on your system.
2. Clone this repository:
   ```
   git clone https://github.com/kcalvelli/nixos.git
   ```
3. Create entries for your hosts in the `hosts/` directory with your specific hardware configuration.
4. Create entries in `modules/users/` with your specific user information.
5. Run `sudo nixos-rebuild switch --flake .#yourhostname` to apply the configuration.

## Customization

To customize this configuration for your own use:

1. Update the hardware-specific modules in `modules/hardware/` to match your system.
2. Modify the user settings in `modules/users/` and `home/` to fit your preferences.
3. Adjust the list of installed packages in various module files to suit your needs.
4. Update the `flake.nix` file to point to your preferred input sources and add any additional inputs you might need.

## Notable Features

- COSMIC desktop environment setup
- AMD CPU and GPU optimizations
- Custom overlay for packages like Brave Browser Nightly and Valent
- Extensive use of Home Manager for user-specific configurations

## Warning

This configuration is highly personalized and will not work out-of-the-box on your system. Use it as a reference or starting point for your own NixOS configuration.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
