# nixos_config

This repository contains my personal, modular, flake-based NixOS configuration for multiple hosts. It is tailored for a KDE Plasma workstation setup, with additional modules for hardware, networking, gaming, development, and automated backups.


## Key Features

- **KDE Plasma 6**: Primary desktop environment, with SDDM, Wayland, Flatpak, and a curated set of KDE applications.
- **Modular Structure**: System, hardware, networking, services, graphics, gaming, and development modules for easy customization and reuse.
- **Home Manager Integration**: User environments managed via Home Manager modules in `home/`.
- **Custom Packages**: Local package definitions in `pkgs/` for software not available in upstream Nixpkgs or with custom patches.
- **Automated Backups**: Rclone-based backup of important directories to Proton Drive, scheduled via systemd.
- **Per-host Configuration**: Each machine (e.g., `edge`, `pangolin`) has its own config under `hosts/`.


## Directory Structure

- `flake.nix`, `flake.lock` — Flake entrypoints
- `hosts/` — Per-host system configurations
- `modules/` — Modular NixOS and Home Manager modules
- `home/` — Home Manager user environment modules and resources
- `pkgs/` — Custom and third-party package definitions
- `README.md` — This file


## Usage Notice & Caution

**This repository is highly customized for my personal NixOS systems and is not intended to be used directly on other machines.**

You may use this repository as a reference for structure, modularization, and flake-based workflows. Many settings, packages, and modules are tailored specifically for my workflow and hardware, and may not be suitable for general use without significant modification.

**Caution:** No secrets (passwords, API keys, tokens, etc.) are included in this configuration by design. For the system to be fully functional, you must perform custom setup outside of NixOS (such as creating environment files, rclone configs, or other secret management). This is a deliberate security measure—review all modules and set up secrets manually as needed.

## Notable Modules

- `modules/desktop/plasma.nix`: KDE Plasma 6 desktop configuration, including SDDM, Flatpak, and curated KDE apps.
- `modules/services/rclone-protondrive.nix`: Automated backup to Proton Drive using rclone and systemd.
- `home/terminal.nix`: Unified terminal, shell, and prompt configuration (Vim, Fish, Starship, Ghostty, etc).
- `pkgs/`: Custom package definitions, including some Qt-based software and other utilities.

## Services That Can Be Enabled

The following services can be enabled in your configuration, and many can be reverse proxied through Caddy:

- **Caddy Proxy** (`services.caddy-proxy.enable`): Secure reverse proxy for web services.
- **OpenWebUI** (`services.openwebui.enable`): AI web interface, reverse proxied at `/ai/*`.
- **Home Assistant** (`services.hass.enable`): Home automation platform, reverse proxied at `/`.
- **ntopng** (`services.ntop.enable`): Network monitoring, reverse proxied at `/ntopng/*`.
- **MQTT Broker** (`services.mqtt.enable`): Local Mosquitto broker for IoT and automation.
- **Matter Server** (`services.matter-server.enable`): Smart home protocol support.
- **Wyoming Voice Containers**: Whisper, Piper, OpenWakeWord (for Home Assistant voice pipelines).
- **Rclone Proton Drive Backup**: Automated backup of `~/Music` and `~/Documents` to Proton Drive.
- **KDEConnect** (`programs.kdeconnect.enable`): Device integration.
- **Partition Manager** (`programs.partition-manager.enable`): Disk/partition management.
- **Flatpak** (`services.flatpak.enable`): Universal Linux app support.
- **Bluetooth, Printing, Sound, Networking, Firewall, SSH, etc.**: Standard NixOS services.

### Example Caddy Reverse Proxy Paths

- `/ai/*` → OpenWebUI (port 8080)
- `/ntopng/*` → ntopng (port 3000)
- `/` → Home Assistant (port 8123)

## Tailscale Networking

This configuration uses Tailscale for secure networking and reverse proxying. **Note:** Your personal Tailscale domain (e.g., `taile0fb4.ts.net`) is hardcoded in the services configuration for Caddy, Home Assistant, OpenWebUI, ntopng, and other reverse-proxied services. If you fork or reuse this configuration, you must update the domain to match your own Tailscale network.

## Manual Setup Required for Proton Drive Backups

The automated backup of `~/Music` and `~/Documents` to Proton Drive via rclone requires some manual setup:

1. **Create and configure your Proton Drive remote in rclone:**
	- rclone is installed automatically by the NixOS configuration.
	- Run `rclone config` and follow the prompts to add a new remote named `protondrive` using the Proton Drive backend.
	- Ensure your config is saved at `~/.config/rclone/rclone.conf` for the `keith` user.
	- Test your remote with `rclone lsd protondrive:`.

2. **Permissions:**
	- The systemd service runs as user `keith`. Make sure this user has access to the source directories and the rclone config file.

3. **First run:**
	- After rebuilding your system, check the timer and service:
	  ```sh
	  systemctl status rclone-protondrive-backup.timer
	  systemctl status rclone-protondrive-backup.service
	  ```
	- You can trigger a manual backup with:
	  ```sh
	  systemctl start rclone-protondrive-backup.service
	  ```

4. **Logs:**
	- Backup logs are written to `~/.local/share/rclone/backup.log`.

**Note:** The backup will only work if the rclone remote is set up and working. This process does not create or configure the rclone remote for you.

## License

This repository is licensed under the MIT License. See `LICENSE` for details.
