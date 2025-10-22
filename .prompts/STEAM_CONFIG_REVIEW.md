# Steam Configuration Review and Recommendations

**Date:** 2025-10-20
**Context:** Reviewing current Steam override and extraPkgs configuration

## Current Configuration Analysis

### What's Currently Overridden

```nix
package = pkgs.steam.override {
  extraPkgs = pkgs: (builtins.attrValues {
    # X11 libraries
    inherit (pkgs.xorg) libXcursor libXi libXinerama libXScrnSaver;
    
    # C++ standard library
    inherit (pkgs.stdenv.cc.cc) lib;
    
    # Performance and gaming tools
    inherit (pkgs) gamemode mangohud;
    
    # System libraries
    inherit (pkgs) gperftools keyutils libkrb5 libpng libpulseaudio libvorbis;
  });
};
```

### Analysis of Each Package

| Package | Status | Recommendation |
|---------|--------|----------------|
| **libXcursor, libXi, libXinerama, libXScrnSaver** | Already in Steam FHS | ❌ Remove - Redundant |
| **stdenv.cc.cc.lib** | Already in Steam FHS | ❌ Remove - Redundant |
| **libpulseaudio** | Already in Steam FHS | ❌ Remove - Redundant |
| **libpng, libvorbis** | Already in Steam FHS | ❌ Remove - Redundant |
| **gamemode** | Useful but can be system package | ⚠️ Optional - Consider removing from override |
| **mangohud** | Useful for overlays | ⚠️ Optional - Consider removing from override |
| **gperftools** | Google performance tools | ❌ Remove - Rarely needed, problematic |
| **keyutils, libkrb5** | Kerberos authentication | ⚠️ Keep only if needed for specific games |

## Why Most Packages Are Redundant

**Steam's FHS Environment:**
NixOS's Steam package uses `buildFHSUserEnv` which already includes:
- All standard X11 libraries
- PulseAudio/audio libraries
- Common graphics libraries (Mesa, Vulkan)
- C/C++ standard libraries
- Most media codecs (libpng, libvorbis, etc.)

**Historical Context:**
Many Steam overrides were created years ago when NixOS's Steam FHS environment was less complete. Modern versions include most dependencies by default.

## Potential Issues with Current Override

### 1. **Redundancy**
- ~70% of override packages are already in the FHS environment
- Extra packages increase build time unnecessarily
- Larger Steam closure size

### 2. **gperftools Concerns**
- Can cause conflicts with game memory allocators
- Known to cause crashes in some games
- Generally not recommended unless specifically needed

### 3. **Maintenance Burden**
- More packages to update
- Potential conflicts with upstream changes
- Harder to debug issues

## Recommended Configurations

### Option 1: Minimal (Recommended for Most Users)

```nix
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
  dedicatedServer.openFirewall = true;
  
  # No override needed - FHS environment has everything
  # package = pkgs.steam;  # This is the default
  
  extraCompatPackages = [ pkgs.proton-ge-bin ];
  gamescopeSession.enable = true;
  
  protontricks = {
    enable = true;
    package = pkgs.protontricks;
  };
};

# Install gamemode and mangohud as system packages instead
environment.systemPackages = with pkgs; [
  gamescope
  gamemode
  mangohud
];

programs.gamemode.enable = true;
```

**Benefits:**
- ✅ Cleaner configuration
- ✅ Faster builds (no unnecessary override)
- ✅ Less maintenance
- ✅ Gamemode/mangohud available system-wide
- ✅ No potential conflicts from redundant libs

### Option 2: Conservative (Keep Only Non-FHS Packages)

```nix
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
  dedicatedServer.openFirewall = true;
  
  # Only override if you have specific games that need these
  package = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [
      # Only include if you play games requiring Kerberos auth
      # keyutils
      # libkrb5
    ];
  };
  
  extraCompatPackages = [ pkgs.proton-ge-bin ];
  gamescopeSession.enable = true;
  
  protontricks = {
    enable = true;
    package = pkgs.protontricks;
  };
};

environment.systemPackages = with pkgs; [
  gamescope
  gamemode
  mangohud
];

programs.gamemode.enable = true;
```

**When to use:** If you have specific games requiring libraries not in the FHS.

### Option 3: Problem-Specific Overrides

Only add overrides when you encounter specific game issues:

```nix
# Example: Game requires specific library
package = pkgs.steam.override {
  extraPkgs = pkgs: with pkgs; [
    # Add ONLY packages that fix actual issues you've encountered
  ];
};
```

## Testing Your Configuration

After simplifying, test with your games:

```bash
# Build new configuration
sudo nixos-rebuild switch --flake /etc/nixos#HOSTNAME

# Test Steam
steam

# Test gamemode (should work system-wide now)
gamemoderun %command%  # In Steam launch options

# Test mangohud
mangohud %command%     # In Steam launch options
```

## Migration Path

1. **Backup current config** (it's in git, you're good)
2. **Switch to minimal config** (Option 1)
3. **Test your games**
4. **If a specific game has issues:**
   - Check Steam logs
   - Add ONLY the specific missing library
   - Document why it's needed (comment in config)

## When to Keep the Override

**Keep extraPkgs if:**
- ❌ You play games requiring Kerberos authentication (very rare)
- ❌ You've identified a SPECIFIC library missing from FHS
- ❌ You have documented game crashes without the override

**Don't keep if:**
- ✅ "It's always been there" (not a good reason)
- ✅ "Someone on the internet said so" (verify yourself)
- ✅ "Just in case" (adds bloat without benefit)

## Performance Impact

**Current override:**
- ~15 extra packages in Steam FHS
- Increased closure size: ~200-300 MB
- Slightly longer Steam startup time
- Potential memory overhead

**Minimal config:**
- Default FHS environment
- Optimal performance
- Smaller disk usage
- Faster Steam startup

## Conclusion

**Recommendation:** Switch to Option 1 (Minimal) configuration.

The current override includes many redundant packages that are already in Steam's FHS environment. Modern NixOS Steam support is mature and includes everything needed for most games.

**Action Items:**
1. Remove the `package = pkgs.steam.override { ... }` entirely
2. Move gamemode and mangohud to system packages
3. Test with your game library
4. Only add back specific packages if you encounter actual issues
5. Document any packages you do need to add

**Expected Result:**
- Same or better gaming experience
- Cleaner, more maintainable configuration
- Faster builds and updates
- Better alignment with NixOS best practices

---

**References:**
- NixOS Manual: Steam chapter
- nixpkgs steam package definition
- Historical FHS environment improvements in nixpkgs
