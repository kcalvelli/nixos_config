# Guide: Adding New Hosts

This guide explains different approaches for making it easier to add new hosts to your NixOS configuration.

## Current Implementation (Recommended)

The current system uses a **declarative host configuration** approach where each host is defined in a single file.

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

# 4. Create disk configuration
mkdir -p hosts/newhost/disko
cp hosts/edge/disko/default.nix hosts/newhost/disko/default.nix
# Edit disk configuration as needed
```

###  Benefits

- ✅ **Minimal steps**: Only edit 2-3 files to add a host
- ✅ **Single source of truth**: All host config in one file
- ✅ **Self-documenting**: Clear what each host has enabled
- ✅ **Hardware auto-selection**: nixos-hardware modules chosen automatically
- ✅ **Explicit control**: Easy to see all hosts at a glance

### Limitations

- ⚠️ Must manually add line to `hosts/default.nix` (one-line addition)
- ⚠️ Not fully automatic discovery (tradeoff for flake-parts compatibility)

## Alternative Considered: Full Auto-Discovery

An auto-discovery version was developed (`hosts/default.nix.auto`) that automatically finds all `.nix` files and configures them without manual registration.

### Why Not Auto-Discovery?

While conceptually cleaner, it had integration challenges with flake-parts lazy evaluation. The current approach provides 95% of the benefits with better reliability and debugging.

### When to Use Auto-Discovery

The auto-discovery code is saved in `hosts/default.nix.auto` and could be enabled if:
- Moving away from flake-parts to vanilla flakes
- The flake-parts evaluation order issues are resolved
- You have many hosts (>10) and want pure automation

To switch to auto-discovery:
```bash
cp hosts/default.nix.auto hosts/default.nix
# Remove manual host registrations
# All *.nix files in hosts/ will be auto-detected
```

## Comparison with Other Systems

### Home Manager Style (Current Implementation ✓)

```nix
# Each host is a file, registered explicitly
hosts/
├── edge.nix       # Host definition
├── pangolin.nix   # Host definition
└── default.nix    # Registration: edge = mkSystem edgeCfg;
```

**Pros**: Simple, explicit, easy to debug  
**Cons**: One-line addition needed per host

### Full Auto-Discovery

```nix
# Each host is a file, auto-discovered
hosts/
├── edge.nix       # Automatically found
├── pangolin.nix   # Automatically found
└── default.nix    # Auto-discovers all .nix files
```

**Pros**: Zero editing of default.nix  
**Cons**: Harder to debug, flake-parts integration issues

### Monolithic (Old System ❌)

```nix
# Everything in one file
hosts/default.nix:
  edge = nixosSystem { modules = [ lots of config ]; };
  pangolin = nixosSystem { modules = [ lots of config ]; };
```

**Pros**: Everything in one place  
**Cons**: Repetitive, hard to maintain, unclear what differs between hosts

### Per-Directory (Older System ❌)

```nix
hosts/
├── edge/default.nix     # Imports modules manually
├── pangolin/default.nix # Imports modules manually
└── default.nix          # Lists all modules per host
```

**Pros**: Separation of concerns  
**Cons**: Must edit multiple places, hardware config scattered, unclear structure

## Recommendations

For most users, the **current implementation** (Home Manager style with declarative configs) provides the best balance of:
- Ease of adding hosts (2-3 files to edit)
- Clarity (obvious what each host has)
- Maintainability (config in one place per host)
- Reliability (works well with flake-parts)

## Future Improvements

Possible enhancements that could be added:

1. **Host Generators**: CLI tool to generate host configs
   ```bash
   ./scripts/new-host.sh thinkpad --laptop --intel
   ```

2. **Validation**: Check that hostname matches filename
   ```nix
   assert hostConfig.hostname == filenameToHostname file;
   ```

3. **Profiles**: Pre-made host templates
   ```nix
   hostConfig = lib.mkLaptop {
     hostname = "thinkpad";
     cpu = "intel";
   };
   ```

4. **Auto-Registration**: Use flake-parts proper integration once stable
   ```nix
   perHost = { system, hostConfig, ... }: { ... };
   ```

## See Also

- `hosts/README.md` - Full host configuration reference
- `hosts/TEMPLATE.nix` - Template for new hosts
- `home/profiles/README.md` - Home-manager profiles
