# axiOS Scripts

This directory contains utility scripts for managing axiOS configurations and installations.

## Directory Structure

```
scripts/
├── shell/              # Shell scripts (*.sh)
│   ├── add-host.sh
│   ├── add-user.sh
│   ├── burn-iso.sh
│   ├── install-axios.sh
│   ├── wallpaper-blur.sh
│   └── update-material-code-theme.sh
├── nix/                # Nix wrapper modules
│   ├── installer.nix
│   └── wallpaper-scripts.nix
└── README.md           # This file
```

**Separation Rationale:**
- `shell/` - Pure shell scripts that can be executed independently
- `nix/` - Nix modules that import shell scripts and configure system integration
- This separation makes scripts easier to test, maintain, and understand

## Available Scripts

### 🔥 burn-iso.sh
Burns the axiOS ISO to a USB drive for installation.

**Usage:**
```bash
sudo ./shell/burn-iso.sh [device]
# Or from project root:
sudo ./scripts/shell/burn-iso.sh [device]
```

**Features:**
- Automatically builds ISO if not present
- Interactive device selection with safety checks
- Progress indication during write
- Optional data verification
- Safe unmounting and ejection

**Examples:**
```bash
sudo ./shell/burn-iso.sh              # Interactive mode
sudo ./shell/burn-iso.sh /dev/sdb     # Direct device specification
sudo ./shell/burn-iso.sh sdb          # Auto-adds /dev/ prefix
```

**Requirements:**
- Root access (uses dd)
- USB drive (will be completely erased)

---

### 🖥️ add-host.sh
Creates a new host configuration interactively.

**Usage:**
```bash
./shell/add-host.sh [hostname]
```

**Features:**
- Interactive prompts for all configuration options
- Automatic registration in flake
- Creates host directory and disk configuration template
- Validates hostname format

**Creates:**
- `hosts/<hostname>.nix` - Host configuration file
- `hosts/<hostname>/disks.nix` - Disk configuration template

**Example:**
```bash
./shell/add-host.sh myworkstation
```

---

### 👤 add-user.sh
Creates a new user configuration interactively.

**Usage:**
```bash
./shell/add-user.sh [username]
```

**Features:**
- Interactive prompts for user details
- Password hashing support
- Home-manager integration
- Auto-discovery and imports
- Validates username format

**Creates:**
- `modules/users/<username>.nix` - User configuration file

**Example:**
```bash
./shell/add-user.sh johndoe
```

---

### 💿 install-axios.sh
Full automated installer for axiOS on bare metal or VMs.

**Usage:**
```bash
sudo ./shell/install-axios.sh
```

**Features:**
- Hardware auto-detection (CPU, GPU, form factor)
- Guided disk selection and partitioning
- Interactive user account creation
- Feature selection (desktop, gaming, virtualization, etc.)
- Network connectivity verification
- Complete system installation with password setup

**What Gets Created:**
- Host configuration (`hosts/<hostname>.nix`)
- Disk configuration (`hosts/<hostname>/disko.nix`)
- User configuration (`modules/users/<username>.nix`)
- Bootable system ready to use

**Use Cases:**
- Fresh installations
- Automated deployments
- VM installations

---

## Workflow Examples

### Creating a New System

1. **Add Host Configuration:**
   ```bash
   ./scripts/shell/add-host.sh mysystem
   ```

2. **Edit Configuration:**
   Edit `hosts/mysystem.nix` and `hosts/mysystem/disks.nix`

3. **Build ISO:**
   ```bash
   nix build .#iso
   ```

4. **Create Bootable USB:**
   ```bash
   sudo ./scripts/shell/burn-iso.sh
   ```

5. **Install on Target:**
   Boot from USB and run automated installer

### Adding a New User

1. **Create User:**
   ```bash
   ./scripts/shell/add-user.sh alice
   ```

2. **Edit Configuration:**
   Customize `modules/users/alice.nix` as needed

3. **Apply Changes:**
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

---

## Nix Integration Modules

The `nix/` directory contains Nix modules that wrap shell scripts for system integration:

### 📦 installer.nix
Configures the axiOS installer ISO with:
- Installation script integration
- Network tools (NetworkManager)
- Disk management utilities
- Development tools
- Auto-clone of configuration repository
- User-friendly shell environment

**Imported by:** `hosts/installer/default.nix`

### 🎨 wallpaper-scripts.nix
Manages wallpaper blur and theme updates with:
- Script installation to `~/scripts/`
- ImageMagick and swaybg dependencies
- Cache directory creation
- DankMaterialShell hook integration

**Imported by:** `home/desktops/common/wallpaper-blur.nix`

---

## Safety Features

All scripts include:
- ✅ Input validation
- ✅ Confirmation prompts for destructive operations
- ✅ Error handling with clear messages
- ✅ Color-coded output for clarity
- ✅ Help documentation (`--help`)

---

## Contributing

When adding new scripts:
1. Follow the established pattern (colors, error handling)
2. Add help text with `--help` flag
3. Include safety checks for destructive operations
4. Update this README

---

## Notes

- Most scripts can run without root, except:
  - `burn-iso.sh` (requires root for dd)
  - `install-axios.sh` (requires root for system installation)
- All scripts use color-coded output (disable with `NO_COLOR=1` if needed)
- Scripts validate input and provide helpful error messages
- Shell scripts in `shell/` can be executed independently
- Nix modules in `nix/` should be imported into NixOS/home-manager configurations

## File Organization Guidelines

When adding new scripts:

1. **Pure Shell Scripts** → `scripts/shell/`
   - Standalone executable scripts
   - Can be run directly
   - Should include proper shebang and error handling

2. **Nix Integration** → `scripts/nix/`
   - Import shell scripts from `shell/`
   - Configure system dependencies
   - Set up activation scripts or services
   - Handle package installations

3. **Keep Concerns Separated**
   - Shell scripts handle logic and user interaction
   - Nix modules handle system integration and dependencies
   - This makes scripts testable and maintainable
