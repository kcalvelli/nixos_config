# Hardware Module Refactoring - System76/Laptop

## Summary

Following the MSI/desktop refactoring, the System76-specific hardware module has been refactored into a generic laptop hardware module.

## Changes

### New Module: `hardware/laptop.nix`

Replaces the overly-specific `hardware/system76.nix` with a more generic laptop module.

**Features:**
- Generic laptop hardware configuration (kernel modules, power management, SSD TRIM)
- Optional System76 hardware integration via `hardware.laptop.enableSystem76`
- Optional Pangolin 12 quirks via `hardware.laptop.enablePangolinQuirks`
- Automatically enabled for:
  - Hosts with `hardware.vendor = "system76"`
  - Hosts with `formFactor = "laptop"` and no specific vendor

### Migration

**Old approach:**
```nix
{
  hostConfig = {
    hardware.vendor = "system76";
  };
  extraConfig = {
    hardware.system76.enable = true;  # Manual enable required
  };
}
```

**New approach (automatic):**
```nix
{
  hostConfig = {
    hardware.vendor = "system76";  # Automatically enables laptop hardware + System76 features
    formFactor = "laptop";
  };
}
```

**Or for generic laptop:**
```nix
{
  hostConfig = {
    formFactor = "laptop";
    hardware.vendor = null;  # Automatically enables generic laptop hardware
  };
}
```

**Manual control (if needed):**
```nix
{
  extraConfig = {
    hardware.laptop = {
      enable = true;
      enableSystem76 = true;         # Only for System76 laptops
      enablePangolinQuirks = true;   # Only for Pangolin 12 model
    };
  };
}
```

### What Moved to Generic

**Now generic (in `hardware/laptop.nix`):**
- Common kernel modules (kvm-amd, nvme, xhci_pci)
- SSD TRIM service

**System76-specific (optional):**
- System76 firmware daemon
- System76 power daemon

**Pangolin 12-specific (optional):**
- `psmouse` blacklist (touchpad quirk)
- MediaTek Wi-Fi configuration (`disable_clc=1`)

### Auto-Enable Logic

Both desktop and laptop hardware modules now follow the same pattern:

**Desktop:**
- `vendor = "msi"` → enables desktopHardware + MSI sensors
- `vendor = null` + `formFactor = "desktop"` → enables desktopHardware

**Laptop:**
- `vendor = "system76"` → enables laptopHardware + System76 features + Pangolin quirks
- `vendor = null` + `formFactor = "laptop"` → enables laptopHardware

### Benefits

1. **Consistent pattern**: Desktop and laptop follow same refactoring approach
2. **More reusable**: Laptop config not tied to one vendor
3. **Better defaults**: Auto-enables for laptop form factor
4. **Clearer separation**: Vendor-specific parts clearly marked
5. **Easier maintenance**: Generic laptop tweaks benefit all laptops
6. **Less boilerplate**: No need to manually enable in extraConfig

## Updated Files

- ✅ `modules/hardware/laptop.nix` - New generic laptop module
- ✅ `modules/default.nix` - Export new module
- ✅ `hosts/default.nix` - Auto-enable logic for laptops
- ✅ `hosts/pangolin.nix` - Removed manual hardware.system76.enable
- ✅ `hosts/TEMPLATE.nix` - Updated vendor comments
- ✅ `scripts/add-host.sh` - Updated prompts
- ✅ `modules/hardware/system76.nix` - **REMOVED** (replaced by laptop.nix)

## Testing

✓ Pangolin configuration builds successfully
✓ `hardware.laptop.enable = true` (auto-enabled)
✓ `hardware.laptop.enableSystem76 = true` (auto-enabled for vendor="system76")
✓ `hardware.system76.power-daemon.enable = true` (System76 daemon working)
