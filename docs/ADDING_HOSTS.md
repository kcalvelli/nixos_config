# Guide: Adding New Hosts

This guide explains how to add new machines to your axiOS configuration.

## How It Works

The system uses a **declarative host configuration** approach where each host is defined in a single file.

### How It Works

1. **One file per host**: `hosts/hostname.nix` contains all host-specific settings
2. **Single registration**: Add one line to `hosts/default.nix` to register the host
3. **Auto-configuration**: Hardware modules and features are automatically selected based on the host config

### To Add a New Host

```bash
# 1. Copy the template
cp hosts/TEMPLATE.nix hosts/newhost.nix

# 2. Edit the configuration
vim hosts/newhost.nix  # Set hostname, hardware, modules, etc.

# 3. Register the host (add one line to hosts/default.nix)
# newhost = mkSystem (import ./newhost.nix { inherit lib; }).hostConfig;

# 4. Create disk configuration (if using separate file)
mkdir -p hosts/newhost/disko
# Copy a template based on your needs:
cp modules/disko/templates/standard-ext4.nix hosts/newhost/disko/default.nix
# OR use luks-ext4.nix for encrypted setup
# OR use btrfs-subvolumes.nix for btrfs with snapshots
# Edit disk configuration as needed
```

### Benefits

- ✅ **Minimal steps**: Only edit 2-3 files to add a host
- ✅ **Single source of truth**: All host config in one file
- ✅ **Self-documenting**: Clear what each host has enabled
- ✅ **Hardware auto-selection**: nixos-hardware modules chosen automatically
- ✅ **Explicit control**: Easy to see all hosts at a glance

## Host Configuration Structure

Each host uses this structure:

```
hosts/
├── hostname.nix              # Host configuration
└── hostname/                 # Optional host-specific files
    └── disko/
        └── default.nix      # Disk layout configuration
```

### Example Host Files

**Simple Configuration** (`hosts/EXAMPLE-simple.nix`): Minimal setup with inline disk config
**Organized Configuration** (`hosts/EXAMPLE-organized.nix`): Full-featured with separate files

See these example files as starting points for your own host configurations.

## Tips and Best Practices

1. **Start with the template**: Always copy `hosts/TEMPLATE.nix` for consistency
2. **Use clear hostnames**: Choose descriptive names that identify the machine
3. **Document special settings**: Add comments explaining unusual configurations
4. **Test in a VM first**: Build and test new host configs before deploying
5. **Keep disko configs separate**: Store disk layouts in `hosts/hostname/disko/`
6. **Match hardware accurately**: Set correct CPU/GPU for optimal performance

## See Also

- `hosts/README.md` - Full host configuration reference
- `hosts/TEMPLATE.nix` - Template for new hosts
- `home/profiles/README.md` - Home-manager profiles
