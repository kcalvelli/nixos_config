# Home Profiles

User profile configurations for different machine types.

## Purpose

Profiles combine common configurations with machine-type-specific additions to create complete user environments.

## Available Profiles

### Workstation (`workstation/`)
Desktop workstation profile with full features:
- All common apps and configs from `common/`
- Gaming tools (`gaming.nix`)
- Peripheral management (`solaar.nix` for Logitech devices)

**Used by:** Desktop machines with full gaming and peripheral support

### Laptop (`laptop.nix`)
Portable laptop profile:
- All common apps and configs from `common/`
- No gaming-specific additions
- No workstation peripherals

**Used by:** Laptop machines (Pangolin)

## Profile Structure

```
profiles/
├── workstation/
│   ├── default.nix      # Imports common + workstation-specific
│   ├── gaming.nix       # User gaming tools (protonup-ng)
│   └── solaar.nix       # Logitech device management
└── laptop.nix           # Imports common only
```

## What Goes Here

**Profile-specific packages:**
- Gaming tools (user-level, not system services)
- Hardware-specific utilities (Logitech management)
- Machine-type-specific configurations

**Shared packages go to:** `common/apps.nix`

## Usage in Host Configuration

```nix
# In hosts/edge/default.nix
home-manager.sharedModules = with homeModules; [ workstation ];

# In hosts/pangolin/default.nix
home-manager.sharedModules = with homeModules; [ laptop ];
```

## Gaming Split

Gaming is intentionally split between system and home-manager:
- **System** (`modules/gaming/`): Steam service, GameMode, gamescope
- **Home** (`profiles/workstation/gaming.nix`): User tools like protonup-ng

This allows the system infrastructure to be shared while keeping user-specific gaming tools in the profile.

## Adding New Profiles

To add a new profile type:
1. Create `profiles/newprofile/default.nix`
2. Import `../common` for base functionality
3. Add profile-specific packages and configs
4. Register in `home/default.nix` under `flake.homeModules`
