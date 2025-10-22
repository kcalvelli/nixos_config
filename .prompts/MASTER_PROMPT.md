# Master Prompt for axiOS Development

## Repository Overview

This is axiOS, a personal NixOS configuration built with flakes. It features modular system configurations, Home Manager integration, and an automated installer for fresh installations.

**Key Characteristics:**
- Declarative configuration using NixOS flakes
- Modular architecture with reusable components
- Personal configuration (not meant for direct forking)
- Automated installer for ease of deployment
- Secure boot support via Lanzaboote
- Modern desktop with Niri compositor

## Critical Constraints and Lessons Learned

### 1. **VERIFY BEFORE GENERATING - Cost of Iteration is High**

**Problem:** Each cycle of "fix, test, discover new error" has real costs in time, resources, and testing effort.

**Required Approach:**
- ✅ **ALWAYS** check existing implementation before generating new code
- ✅ **COMPARE** generated templates against source files they're based on
- ✅ **READ** the actual repository structure, don't assume
- ✅ **TEST** mentally by walking through the logic before committing

**Example from Session:**
- Generated `hosts/default.nix` had wrong structure: `{ iso = ...; }`
- Real structure: `{ flake.nixosConfigurations = { installer = ...; }; }`
- This caused 4 sequential fixes, each fixing one error but revealing another
- **Should have:** Compared against real `hosts/default.nix` first

### 2. **Repository Structure and Conventions**

**Cache Configuration:**
- ✅ Binary cache configuration lives in `modules/system/nix.nix`
- ❌ NOT in `flake.nix` nixConfig (even though this works)
- **Why:** Maintains consistency across the repository

**Module Organization:**
- System-level: `modules/` (NixOS modules)
- User-level: `home/` (Home Manager)
- Each major module has a README explaining organization
- See `docs/PACKAGES.md` for package placement guidelines

**File Locations:**
```
modules/system/nix.nix          # Nix settings, binary caches, GC
modules/system/packages.nix     # System-level packages
modules/users/                  # User account definitions (auto-discovered)
home/                           # Home Manager configurations
hosts/                          # Per-machine configurations
hosts/default.nix               # Host registration and builder functions
```

### 3. **Generated Code Must Match Repository Patterns**

When the installer generates configuration files, they MUST match the existing patterns exactly:

**hosts/default.nix Structure:**
```nix
{ inputs, self, lib, ... }:
let
  # Helper functions
  hardwareModules = ...;
  buildModules = ...;
  mkSystem = ...;
  installerModules = ...;
in
{
  flake.nixosConfigurations = {
    installer = ...;
    # User hosts added here
  };
}
```

**NOT:**
```nix
{ iso = ...; }  # Wrong! Doesn't match flake expectations
```

### 4. **Type Safety in Nix**

**Common Type Errors:**
- `swapDevices.size` expects integer (MB), not string
- Conversion: `"8G"` → `(builtins.fromJSON "8") * 1024` → `8192`
- Nix attributes cannot be duplicated (`imports` appeared twice)

**String to Integer Conversion:**
```nix
# Wrong:
size = builtins.replaceStrings ["G"] ["000"] "8G";  # → "8000" (string)

# Right:
size = (builtins.fromJSON (builtins.replaceStrings ["G"] [""] "8G")) * 1024;  # → 8192 (int)
```

### 5. **Binary Caches are Critical for Installation**

**Problem:** Building Niri from source causes SIGABRT (exit code 101) failures.

**Solution:**
- Add all required binary caches to `modules/system/nix.nix`
- Pass explicit cache options to `nixos-install` command
- Use `--option accept-flake-config true`

**Required Caches:**
```nix
extra-substituters = [
  "https://cache.nixos.org"       # Official NixOS
  "https://niri.cachix.org"       # Niri compositor (CRITICAL)
  "https://numtide.cachix.org"    # Numtide tools
];
```

### 6. **Personal Data Must Not Leak to Fresh Installations**

**Critical Security Issue:**
The installer clones the entire repository, including personal configurations.

**Required Cleanup:**
```bash
# Remove personal hosts
rm -f hosts/edge.nix hosts/pangolin.nix
rm -rf hosts/edge hosts/pangolin

# Remove personal users
rm -f modules/users/keith.nix

# Rewrite hosts/default.nix to remove personal host registrations
```

**Keep:**
- Templates (TEMPLATE.nix, EXAMPLE-*.nix)
- Module structure
- Documentation
- Installer configuration

### 7. **User Account Creation**

The installer now creates user accounts automatically during installation.

**Flow:**
1. Prompt for username, full name, email
2. Generate `modules/users/$USERNAME.nix`
3. Add appropriate groups based on enabled features
4. Set passwords for both user and root during install
5. User can log in immediately after installation

**No longer required:**
- Manual user creation post-install
- Editing user templates after installation
- Root login as primary account

### 8. **Testing Strategy**

**Before Committing Generated Code:**
```bash
# 1. Verify bash syntax
bash -n scripts/install-axios.sh

# 2. Verify generated Nix syntax
nix-instantiate --parse /tmp/test_generated.nix

# 3. Compare structure to real files
diff -u <(extract-real) <(extract-generated)

# 4. Check flake metadata
nix flake metadata .
```

**For Type-Sensitive Changes:**
```bash
# Test type conversions
nix eval --expr 'builtins.fromJSON "8" * 1024'  # Should be integer

# Verify attribute uniqueness
grep -n "imports = " generated.nix  # Should appear once per module
```

### 9. **Incremental vs Comprehensive Fixes**

**Anti-pattern:** Making small fixes without understanding full context
- Leads to: Error → Fix → New Error → Fix → New Error...
- Cost: Multiple test cycles, user frustration

**Better approach:** 
1. Understand the complete structure
2. Compare generated vs actual
3. Fix all related issues in one comprehensive change
4. Test thoroughly before committing

**Example:**
Instead of 4 commits fixing:
1. Duplicate imports
2. Wrong function call
3. Missing attributes
4. Wrong return structure

Make 1 commit:
1. Generate correct structure matching repository exactly

### 10. **Documentation Requirements**

When making significant changes:
- ✅ Update relevant docs in `docs/`
- ✅ Update module READMEs if affected
- ✅ Update main README.md if user-facing changes
- ✅ Keep documentation accurate with implementation

**Changed installer behavior?**
- Update `docs/INSTALLATION.md`
- Update `scripts/README.md`
- Update main `README.md` if it mentions the feature

## Common Operations

### Adding a Binary Cache
1. Edit `modules/system/nix.nix`
2. Add to `extra-substituters`
3. Add to `extra-trusted-substituters` if needed
4. Add public key to `extra-trusted-public-keys`

### Modifying Installer Generated Code
1. Check what the real repository structure looks like
2. Find the template in `scripts/install-axios.sh`
3. Update the heredoc (<<'EOF' ... EOF) to match real structure
4. Test the generated output syntax
5. Test an actual installation if possible

### Adding Features to Installer
1. Add global variables at top of script
2. Add interactive prompt function
3. Update summary display
4. Update generated host config template
5. Update documentation

## Session Recovery

If starting a new session:

1. **Read this file first**
2. Check recent commits: `git log --oneline -10`
3. Understand current state before making changes
4. If fixing errors, find root cause, don't patch symptoms

## Key Files to Reference

- `hosts/default.nix` - Host registration pattern
- `modules/system/nix.nix` - Binary cache configuration
- `scripts/install-axios.sh` - Automated installer
- `docs/INSTALLATION.md` - Installation documentation
- `docs/PACKAGES.md` - Package organization guidelines

## Anti-Patterns to Avoid

❌ Adding configuration to `flake.nix` when it belongs in modules
❌ Making incremental fixes without understanding structure
❌ Assuming generated code matches real code
❌ Ignoring type requirements in Nix
❌ Not testing generated templates
❌ Including personal data in installer templates
❌ Building large packages from source (use binary caches!)
❌ Duplicate attributes in Nix modules

## Success Patterns

✅ Compare generated code to source files
✅ Verify types match requirements
✅ Test syntax before committing
✅ Make comprehensive fixes, not incremental patches
✅ Keep documentation in sync with code
✅ Use binary caches for expensive builds
✅ Clean personal data from generated configs
✅ Follow repository conventions consistently

---

**Last Updated:** 2025-10-20
**Session Context:** Installer improvements, type fixes, user account creation
