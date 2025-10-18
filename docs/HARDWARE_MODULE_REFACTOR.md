# Hardware Module Refactoring

## Summary

The vendor-specific hardware modules (MSI and System76) have been refactored into generic form-factor modules (desktop and laptop) since most of the configuration was not vendor-specific.

## Changes Overview

### Desktop Hardware Module (`hardware/desktop.nix`)
Replaces `hardware/msi.nix` - see details below.

### Laptop Hardware Module (`hardware/laptop.nix`)
Replaces `hardware/system76.nix` - see [HARDWARE_LAPTOP_REFACTOR.md](./HARDWARE_LAPTOP_REFACTOR.md) for details.

---

## Desktop Module Refactoring

### New Module: `hardware/desktop.nix`

Replaces the overly-specific `hardware/msi.nix` with a more generic desktop workstation module.

**Features:**
- Generic desktop hardware configuration (Logitech peripherals, kernel modules, power management)
- Optional MSI sensor support via `hardware.desktop.enableMsiSensors`
- Automatically enabled for:
  - Hosts with `hardware.vendor = "msi"`
  - Hosts with `formFactor = "desktop"` and no specific vendor

### Migration

**Old approach:**
```nix
{
  hostConfig = {
    hardware.vendor = "msi";
  };
  extraConfig = {
    hardware.msi.enable = true;  # Manual enable required
  };
}
```

**New approach (automatic):**
```nix
{
  hostConfig = {
    hardware.vendor = "msi";  # Automatically enables desktop hardware + MSI sensors
  };
}
```

**Or for generic desktop:**
```nix
{
  hostConfig = {
    formFactor = "desktop";
    hardware.vendor = null;  # Automatically enables desktop hardware
  };
}
```

**Manual control (if needed):**
```nix
{
  extraConfig = {
    hardware.desktop = {
      enable = true;
      enableMsiSensors = true;  # Only if you have MSI motherboard
    };
  };
}
```

### What Moved to Generic

**Now generic (in `hardware/desktop.nix`):**
- Logitech Unifying receiver support
- Common kernel modules (kvm-amd, nvme, xhci_pci, ahci, etc.)
- Power management (schedutil governor)
- Desktop services (fstrim, irqbalance)
- Power profiles daemon disabled (not useful on desktops)

**Still MSI-specific (optional):**
- `nct6775` kernel module (Super I/O sensors)
- `acpi_enforce_resources=lax` kernel parameter

### Backward Compatibility

The old `msi` module has been **removed** as it was not being used anywhere in the configuration. All hosts using `hardware.vendor = "msi"` now automatically use the new `desktopHardware` module.

### Benefits

1. **More reusable**: Desktop hardware config not tied to one vendor
2. **Better defaults**: Auto-enables for desktop form factor
3. **Clearer separation**: MSI-specific parts are clearly marked
4. **Easier maintenance**: Generic desktop tweaks benefit all desktops
5. **Less boilerplate**: No need to manually enable in extraConfig

## Updated Files

- ✅ `modules/hardware/desktop.nix` - New generic module
- ✅ `modules/default.nix` - Export new module
- ✅ `hosts/default.nix` - Auto-enable logic for vendors and form factors
- ✅ `hosts/edge.nix` - Removed manual hardware.msi.enable
- ✅ `hosts/EXAMPLE-organized.nix` - Updated example
- ✅ `scripts/add-host.sh` - Updated prompts
- ✅ `modules/hardware/msi.nix` - **REMOVED** (replaced by desktop.nix)
