# Host Configuration

This directory contains host-specific configurations for NixOS systems. Each host is defined in a single `.nix` file that declares all its properties in one place.

## Quick Start: Adding a New Host

### Step 1: Choose Your Approach

**Simple (everything in one file)**: See `EXAMPLE-simple.nix`
- No directory needed
- Disk config inline in `extraConfig`
- Best for straightforward setups

**Organized (separate files)**: See `EXAMPLE-organized.nix`
- Create `hostname/` directory
- Disk config in separate file
- Best for complex setups or shared configs

### Step 2: Create Host Configuration File

Copy the appropriate example or template:

```bash
# For simple inline approach:
cp hosts/EXAMPLE-simple.nix hosts/myhost.nix

# OR for organized approach:
cp hosts/EXAMPLE-organized.nix hosts/myhost.nix
mkdir -p hosts/myhost  # Only if using separate disk file

# OR start from scratch:
cp hosts/TEMPLATE.nix hosts/myhost.nix
# Edit hosts/myhost.nix to customize
```

Add one line to register your host:

```nix
flake.nixosConfigurations = {
  edge = mkSystem edgeCfg;
  pangolin = mkSystem pangolinCfg;
  myhost = mkSystem (import ./myhost.nix { inherit lib; }).hostConfig;  # Add this line
};
```

### Step 4: Configure Disks (if not done inline)

You have two options for disk configuration:

**Option A: Inline (for simple setups)**

Define disks directly in the host config's `extraConfig`:

```nix
# hosts/thinkpad.nix
extraConfig = {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/...";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/...";
    fsType = "vfat";
  };
};
```

**Option B: Separate file (for complex setups)**

Create a dedicated disk configuration file:

```bash
mkdir -p hosts/thinkpad
# Create hosts/thinkpad/disks.nix with your disk configuration
```

Then reference it in your host config:

```nix
diskConfigPath = ./thinkpad/disks.nix;
```

That's it! Your host is now configured.

## Example: Adding a ThinkPad Laptop

**File: `hosts/thinkpad.nix`**

```nix
{ lib, ... }:
{
  hostConfig = {
    hostname = "thinkpad";
    system = "x86_64-linux";
    formFactor = "laptop";
    
    hardware = {
      vendor = null;      # Generic hardware
      cpu = "intel";
      gpu = "intel";
      hasSSD = true;
      isLaptop = true;    # Enables laptop power management modules
    };
    
    modules = {
      system = true;
      desktop = true;
      development = true;
      graphics = true;
      networking = true;
      users = true;
      virt = true;        # Enable containers for development
      gaming = false;     # Disable gaming on laptop
      services = false;   # No server services
    };
    
    virt = {
      containers.enable = true;
      libvirt.enable = false;  # Skip full VM support
    };
    
    homeProfile = "laptop";
    
    diskConfigPath = ./thinkpad/disko;
  };
}
```

**Add to `hosts/default.nix`:**

```nix
thinkpad = mkSystem (import ./thinkpad.nix { inherit lib; }).hostConfig;
```

## Configuration Reference

### hostname
The system hostname. Must match the filename (without `.nix` extension).

### system
Target architecture:
- `"x86_64-linux"` - Standard x86_64 systems
- `"aarch64-linux"` - ARM64 systems (e.g., Raspberry Pi)

### formFactor
System type for automatic hardware configuration:
- `"desktop"` - Automatically enables desktop hardware module (with vendor-specific options)
- `"laptop"` - Automatically enables laptop hardware module (with vendor-specific options)
- `"server"` - Headless server (no automatic hardware module)

### hardware
Automatically selects appropriate hardware configuration based on form factor:

- **vendor**: `"msi"` (desktop), `"system76"` (laptop), or `null`
  - `"msi"` - Enables generic desktop hardware with MSI motherboard sensor support
  - `"system76"` - Enables generic laptop hardware with System76 firmware/power integration
  - `null` - Generic hardware based on `formFactor` (desktop or laptop)
  
- **cpu**: `"amd"` or `"intel"`
  - Includes CPU-specific optimizations from nixos-hardware
  
- **gpu**: `"amd"`, `"nvidia"`, or `"intel"`
  - Includes GPU drivers and modules
  
- **hasSSD**: `true` or `false`
  - Enables SSD-specific optimizations (TRIM, etc.)
  
- **isLaptop**: `true` or `false`
  - Adds laptop-specific hardware support (battery, power management)

### modules
Enable/disable major system components (all optional, shown with typical defaults):

| Module | Description | Typical Use |
|--------|-------------|-------------|
| `system` | Base configuration (boot, nix settings) | Always `true` |
| `desktop` | Desktop environments (Niri) | Desktops/Laptops |
| `development` | Dev tools, IDEs, language support | Workstations |
| `services` | Server services (Caddy, MQTT, etc.) | Servers |
| `graphics` | GPU drivers, acceleration | Desktops/Laptops |
| `networking` | Network, firewall configuration | Always `true` |
| `users` | User account management | Always `true` |
| `virt` | Virtualization (libvirt, Docker) | Optional |
| `gaming` | Steam, game support | Gaming PCs |

### services
Specific services to enable (optional):

```nix
services = {
  caddy-proxy.enable = true;  # Reverse proxy
  openwebui.enable = true;     # AI chat interface
  # ntop.enable = true;        # Network monitoring
  # hass.enable = true;        # Home Assistant
};
```

### virt
Virtualization options:

```nix
virt = {
  libvirt.enable = true;      # Full VM support (QEMU/KVM)
  containers.enable = true;   # Docker, Podman
};
```

### homeProfile
Specifies which home-manager configuration to use. Must match a directory in `home/profiles/`:
- `"workstation"` - Full desktop with all development tools
- `"laptop"` - Mobile-optimized, battery-conscious settings
- Custom: Create `home/profiles/myprofile/` and use `"myprofile"`

### extraConfig
Any additional NixOS configuration as an attribute set:

```nix
extraConfig = {
  time.hardwareClockInLocalTime = true;  # For Windows dual-boot
  boot.kernelParams = [ "quiet" ];
  # Any valid NixOS option can go here
};
```

### diskConfigPath
Path to disk configuration file (OPTIONAL - can also define in `extraConfig`):

```nix
# Option 1: Use a separate file
diskConfigPath = ./hostname/disks.nix;

# Option 2: Omit and define in extraConfig instead
# extraConfig = {
#   fileSystems."/" = { ... };
# };
```

## Directory Structure

The structure depends on your disk configuration choice:

**Minimal (inline disk config):**
```
hosts/
├── default.nix          # Host registry
├── TEMPLATE.nix         # Template
├── myhost.nix           # Host config (includes disk config inline)
```

**Organized (separate disk file):**
```
hosts/
├── default.nix          # Host registry  
├── TEMPLATE.nix         # Template
├── myhost.nix           # Host configuration
└── myhost/              # Host-specific files (optional)
    ├── disks.nix        # Disk configuration
    └── disko/           # Disko templates for reinstalls (optional)
        └── default.nix
```

**Note**: The `myhost/` directory is only needed if you choose to use separate disk configuration files. For simple setups, you can define everything inline in `myhost.nix`.

## Benefits of This Approach

1. **Single Source of Truth**: Each host defined in one file
2. **Easy Discovery**: All hosts visible at a glance
3. **Type-Safe**: Configuration structure is self-documenting
4. **Minimal Boilerplate**: Only specify what's different
5. **Hardware Auto-Selection**: nixos-hardware modules chosen automatically
6. **Explicit Control**: Clear what each host has enabled
7. **Easy Migration**: Simple to copy/modify for new hosts

## Troubleshooting

### Host not appearing after adding to default.nix

Run `nix flake check` to see if there are syntax errors:

```bash
nix flake check --no-build
```

### Build fails with "file not found"

Ensure your disk configuration exists:

```bash
ls -la hosts/myhost/disko/default.nix
```

### Want to test configuration before building

Evaluate the configuration:

```bash
nix eval .#nixosConfigurations.myhost.config.networking.hostName
```

## See Also

- `home/profiles/README.md` - Home-manager profiles
- `modules/README.md` - Available NixOS modules
- `TEMPLATE.nix` - Template for new hosts
