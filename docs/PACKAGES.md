# Package Organization Guide

This document explains how packages are organized throughout the configuration and where to add new packages.

## Overview

Packages are deliberately split between **system-level** (`modules/`) and **user-level** (`home/`) to maintain proper separation of concerns while keeping related functionality modular.

## Quick Reference

| Package Type | System Location | Home Location |
|--------------|----------------|---------------|
| Core utilities | `modules/system/` | - |
| Desktop services | `modules/desktop/` | - |
| Development tools | `modules/development/` | `home/common/terminal/` |
| Gaming infrastructure | `modules/gaming/` | `home/profiles/workstation/gaming.nix` |
| Graphics/GPU | `modules/graphics/` | - |
| Desktop apps | `modules/desktop/` (if privileged) | `home/common/apps.nix` |
| Wayland tools | `modules/desktop/wayland/` | `home/desktops/wayland/` |
| User applications | - | `home/common/apps.nix` |

## System vs Home-Manager Decision Tree

### Install at System Level (`modules/`) if:
- ✓ Requires privileged access or runs as a service
- ✓ Needs hardware access (GPU tools, peripherals)
- ✓ Must be available to root or multiple users
- ✓ Provides system-wide infrastructure (containers, VMs)
- ✓ Requires firewall rules or system networking

### Install with Home-Manager (`home/`) if:
- ✓ User desktop application
- ✓ Has user-specific configuration/dotfiles
- ✓ User preference tool (themes, fonts)
- ✓ Personal productivity software
- ✓ User-specific development tools

## Package Lists Pattern

Large modules use `packages.nix` for organization:

```nix
# modules/example/packages.nix
{ pkgs }: {
  category1 = with pkgs; [ pkg1 pkg2 ];
  category2 = with pkgs; [ pkg3 pkg4 ];
}

# modules/example/default.nix
let packages = import ./packages.nix { inherit pkgs; };
in {
  environment.systemPackages = 
    packages.category1 ++ packages.category2;
}
```

### Modules Using Package Lists:
- `modules/system/packages.nix` - Core system utilities
- `modules/development/packages.nix` - Development tools
- `modules/graphics/packages.nix` - GPU utilities
- `home/common/packages.nix` - User applications
- `home/desktops/wayland/packages.nix` - Wayland tools

## Directory Structure

```
.
├── modules/                          # System-level (NixOS modules)
│   ├── system/                       # Core system utilities
│   │   ├── packages.nix             # Categorized package lists
│   │   ├── default.nix              # Uses packages.nix
│   │   └── README.md                # Module documentation
│   ├── desktop/                      # Desktop environments
│   ├── development/                  # Development tools
│   │   ├── packages.nix
│   │   └── README.md
│   ├── gaming/                       # Gaming infrastructure
│   ├── graphics/                     # GPU configuration
│   │   ├── packages.nix
│   │   └── README.md
│   └── virtualisation/               # VMs and containers
│
└── home/                             # User-level (home-manager)
    ├── common/                       # Shared user configs
    │   ├── packages.nix             # User applications
    │   ├── apps.nix                 # Uses packages.nix
    │   ├── terminal/                # Shell configurations
    │   ├── browser/                 # Browser configs
    │   └── README.md
    ├── desktops/                     # Desktop-specific user configs
    │   └── wayland/
    │       ├── packages.nix         # Wayland user tools
    │       ├── common/apps.nix      # Uses packages.nix
    │       └── README.md
    └── profiles/                     # Machine-type profiles
        ├── workstation/              # Desktop profile
        │   ├── gaming.nix           # User gaming tools
        │   └── solaar.nix           # Peripheral management
        ├── laptop.nix                # Laptop profile
        └── README.md
```

## Common Patterns

### 1. Categories with Comments
Files use section headers for clarity:
```nix
environment.systemPackages = with pkgs; [
  # === Network Tools ===
  curl wget
  
  # === System Monitoring ===
  htop gtop
];
```

### 2. Intentional Duplication
Some tools appear in both system and home-manager by design:

**Example: Shell tools (fish, eza, fzf)**
- **System** (`modules/development/`): Available for root and system operations
- **Home** (`home/common/terminal/`): User-specific configuration via `programs.*`

This is intentional and documented in module README files.

### 3. Gaming Split
Gaming infrastructure is split across two locations:

**System** (`modules/gaming/`):
- Steam (service + firewall rules)
- GameMode (system daemon)
- Gamescope (privileged compositor)

**Home** (`home/profiles/workstation/gaming.nix`):
- protonup-ng (user tool)
- Game-specific configs

### 4. Desktop Apps Split
Desktop applications are split by privilege requirement:

**System** (`modules/desktop/`):
- VPN clients (network configuration)
- OBS (hardware access)
- System services (kdeconnect, localsend)

**Home** (`home/common/apps.nix`):
- Productivity apps (LibreOffice, Obsidian)
- Media apps (Celluloid, Pinta)
- Communication (Discord)

## Adding New Packages

### Step 1: Determine Location
Use the decision tree above to choose system or home-manager.

### Step 2: Find the Right Module
- System utilities → `modules/system/packages.nix`
- Development tools → `modules/development/packages.nix`
- Desktop apps → `home/common/packages.nix`
- Wayland tools → `home/desktops/wayland/packages.nix`

### Step 3: Add to Category
Add the package to the appropriate category in `packages.nix`:
```nix
monitoring = with pkgs; [
  htop
  gtop
  your-new-tool  # Add here
];
```

### Step 4: Check README
Read the module's README.md to ensure the package belongs there.

## Module Documentation

Each major module directory contains a README.md explaining:
- Purpose and scope
- Package organization
- What belongs in that module
- Where alternatives should go
- Configuration examples

**Read these first** when adding packages to understand the module's role.

## Examples

### Adding a System Monitoring Tool
1. Location: System-level (needs hardware access)
2. Module: `modules/system/packages.nix`
3. Category: `monitoring`
4. Update: Add to list in `packages.nix`

### Adding a Text Editor
1. Location: User-level (user preference)
2. Module: `home/common/packages.nix`
3. Category: Create new `editors` category or add to `documents`
4. Update: Add to list in `packages.nix`

### Adding a Wayland Widget
1. Location: User-level (UI tool)
2. Module: `home/desktops/wayland/packages.nix`
3. Category: `utilities`
4. Update: Add to list in `packages.nix`

## Maintenance

### Reviewing Package Organization
```bash
# Find all package lists
find . -name "packages.nix"

# Find all READMEs
find . -name "README.md" | grep -E "(modules|home)"
```

### Adding New Categories
When a category grows beyond 5-10 packages, consider:
1. Splitting into sub-categories in `packages.nix`
2. Creating a dedicated sub-module
3. Documenting the new organization in README.md

### Refactoring Guidance
- Keep modules focused on a single concern
- Document intentional duplication in READMEs
- Update package lists before adding to default.nix
- Add comments for non-obvious categorizations

## Philosophy

This organization maintains modularity while improving discoverability:

1. **Modular**: Related packages stay in their logical modules
2. **Discoverable**: Package lists and READMEs make it clear where things go
3. **Maintainable**: Categories and comments make it easy to find and update packages
4. **Flexible**: New modules and categories can be added without restructuring

The goal is to make it immediately clear where a new package should go based on its purpose and requirements.
