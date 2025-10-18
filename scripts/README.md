# axiOS Scripts

This directory contains utility scripts for managing axiOS configurations and installations.

## Available Scripts

### 🔥 burn-iso.sh
Burns the axiOS ISO to a USB drive for installation.

**Usage:**
```bash
sudo ./burn-iso.sh [device]
```

**Features:**
- Automatically builds ISO if not present
- Interactive device selection with safety checks
- Progress indication during write
- Optional data verification
- Safe unmounting and ejection

**Examples:**
```bash
sudo ./burn-iso.sh              # Interactive mode
sudo ./burn-iso.sh /dev/sdb     # Direct device specification
sudo ./burn-iso.sh sdb          # Auto-adds /dev/ prefix
```

**Requirements:**
- Root access (uses dd)
- USB drive (will be completely erased)

---

### 🖥️ add-host.sh
Creates a new host configuration interactively.

**Usage:**
```bash
./add-host.sh [hostname]
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
./add-host.sh myworkstation
```

---

### 👤 add-user.sh
Creates a new user configuration interactively.

**Usage:**
```bash
./add-user.sh [username]
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
./add-user.sh johndoe
```

---

### 💿 install-axios.sh
Full automated installer for axiOS on bare metal or VMs.

**Usage:**
```bash
sudo ./install-axios.sh
```

**Features:**
- Hardware auto-detection (CPU, GPU, form factor)
- Guided disk selection and partitioning
- Feature selection (desktop, gaming, virtualization, etc.)
- Network connectivity verification
- Complete system installation

**Use Cases:**
- Fresh installations
- Automated deployments
- VM installations

---

## Workflow Examples

### Creating a New System

1. **Add Host Configuration:**
   ```bash
   ./add-host.sh mysystem
   ```

2. **Edit Configuration:**
   Edit `hosts/mysystem.nix` and `hosts/mysystem/disks.nix`

3. **Build ISO:**
   ```bash
   nix build .#iso
   ```

4. **Create Bootable USB:**
   ```bash
   sudo ./burn-iso.sh
   ```

5. **Install on Target:**
   Boot from USB and run automated installer

### Adding a New User

1. **Create User:**
   ```bash
   ./add-user.sh alice
   ```

2. **Edit Configuration:**
   Customize `modules/users/alice.nix` as needed

3. **Apply Changes:**
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

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
