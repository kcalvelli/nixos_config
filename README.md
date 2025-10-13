# NixOS Configuration

This repository contains my personal [ NixOS ] (https://nixos.org)
  configuration.> **Disclaimer * *
  > This setup is designed specifically for my own machines and
  workflow.> It
  is
  provided * *for reference only * *.> If you
  use
  any
  part
  of
  it, do so at your own risk — it is not intended to be a turnkey solution for others.

---

## Overview

The configuration is managed with [flakes](https://nixos.wiki/wiki/Flakes) and is structured to support both system-level modules and [home-manager](https://github.com/nix-community/home-manager) user configurations. It includes:

- System definitions (hardware, services, desktop environment, etc.)
- User environments via Home Manager
- Development shells for reproducible work environments
- Integration with common tools I use day-to-day

The structure evolves as my needs change, and it may not follow community conventions perfectly.

---

## Usage

If you are just browsing for ideas:

- Look at the `flake.nix` and `flake.lock` for inputs and overall structure.
- Check out `modules/` and `hosts/` for how I split out configuration by purpose.
- See `home/` for Home Manager user configs.

If you want to experiment with parts of this config on your own system:

1. **Do not clone and apply directly.**
You should copy only the relevant snippets you understand.
2. Adapt them to your hardware, users, and preferences.
3. Read the [NixOS manual](https://nixos.org/manual/nixos/stable/) and [Home Manager manual](https://nix-community.github.io/home-manager/) before using anything from here.

---

## Structure

- `flake.nix` – Entry point for the configuration.
- `flake.lock` – Input lock file.
- `hosts/` – Host-specific system configurations.
- `modules/` – Reusable NixOS modules (services, options, tweaks).
- `home/` – Home Manager configurations for users.
- `devshells/` – Tech stack specific development environments.

---

## Credits & Inspirations

This configuration has been hacked together over a long period of time, borrowing ideas and snippets from many sources. I no longer recall every repo, blog, or gist that influenced this work, but I want to acknowledge the wider NixOS community for sharing their configs openly.

In particular, these kinds of projects have been especially influential across the ecosystem:

- [nix-community](https://github.com/nix-community) projects (e.g. home-manager, devshell, flakes examples)
- [hlissner/dotfiles](https://github.com/hlissner/dotfiles) — a popular early reference
- [rycee/home-manager](https://github.com/nix-community/home-manager) — for user environments
- [nixpkgs](https://github.com/NixOS/nixpkgs) examples and modules scattered throughout GitHub

If you see something here that clearly originated from your work and you’d like explicit credit, please open an issue or PR and I’ll be happy to add it.

---

## License

Unless otherwise noted in specific files, all configuration here is shared under the MIT license.
This means you are free to copy and adapt parts of it, but **I do not provide support** if it breaks on your setup.

---

## Notes

- This is a **living configuration**. Expect breaking changes at any time.
- Some files reference secrets, private paths, or hardware-specific options not included in the repo.
- Again: **use for inspiration, not as a drop-in system.**
