# Development Module

System-level development tools and services.

## Purpose

Provides system-wide development tools, editors, shell environments, and development services available to all users.

## Package Organization

Packages are organized in `packages.nix` by category:
- **editors**: System text editors and IDEs (vim, vscode)
- **nix**: Nix development tools (devenv, nil LSP)
- **shell**: Shell and terminal utilities (fish, starship, bat, eza, fzf)
- **vcs**: Version control systems (gh)
- **ai**: AI/ML development tools (whisper-cpp, copilot-cli)

## What Goes Here

**System-level packages:**
- System editors (vim) needed for root operations
- Development tools requiring system-wide availability
- Shell environments and utilities
- Language servers and development services

**User development configs go to:** `home/common/terminal/`

## Services

- `lorri`: Nix environment management
- `vscode-server`: Remote VSCode server support

## Programs

- `direnv`: Environment variable management
- `bash`: Configured to auto-launch Fish shell

## Note on Shell Tools

Shell tools (fish, starship, eza, etc.) are intentionally in both system and home-manager:
- **System**: Ensures availability for root and system operations
- **Home**: Provides user-specific configuration via `programs.*` modules

