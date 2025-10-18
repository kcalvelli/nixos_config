# Hardware Module

Hardware-specific configurations for different system types.

## Purpose

Provides hardware configurations optimized for different form factors (desktop, laptop) with optional vendor-specific features.

## Available Modules

### `desktop.nix` - Desktop Hardware
Generic desktop workstation configuration.

**Auto-enabled for:**
- `hardware.vendor = "msi"`
- `formFactor = "desktop"` (with no specific vendor)

**Features:**
- Logitech Unifying receiver support
- Standard kernel modules (kvm-amd, nvme, xhci_pci, ahci, etc.)
- Desktop power management (schedutil governor)
- Desktop services (fstrim, irqbalance)
- Power profiles daemon disabled (not useful on desktops)

**Optional MSI motherboard support:**
```nix
hardware.desktop.enableMsiSensors = true;  # Auto-enabled for vendor="msi"
```
Enables:
- nct6775 kernel module (Super I/O sensors)
- acpi_enforce_resources=lax parameter

### `laptop.nix` - Laptop Hardware
Generic laptop configuration.

**Auto-enabled for:**
- `hardware.vendor = "system76"`
- `formFactor = "laptop"` (with no specific vendor)

**Features:**
- Standard kernel modules (kvm-amd, nvme, xhci_pci)
- SSD TRIM service

**Optional System76 support:**
```nix
hardware.laptop.enableSystem76 = true;  # Auto-enabled for vendor="system76"
```
Enables:
- System76 firmware daemon
- System76 power daemon

**Optional Pangolin 12 quirks:**
```nix
hardware.laptop.enablePangolinQuirks = true;  # Auto-enabled for vendor="system76"
```
Enables:
- psmouse blacklist (touchpad quirk)
- MediaTek Wi-Fi configuration

### `common.nix` - Common Hardware
Base hardware configuration imported by both desktop and laptop modules.

**Features:**
- AMD CPU microcode updates
- Enable all firmware

## Usage in Host Configuration

Hardware modules are automatically enabled based on vendor and form factor:

```nix
# MSI desktop - gets desktop hardware + MSI sensors
{
  formFactor = "desktop";
  hardware.vendor = "msi";
}

# System76 laptop - gets laptop hardware + System76 features
{
  formFactor = "laptop";
  hardware.vendor = "system76";
}

# Generic desktop - gets desktop hardware only
{
  formFactor = "desktop";
  hardware.vendor = null;
}

# Generic laptop - gets laptop hardware only
{
  formFactor = "laptop";
  hardware.vendor = null;
}
```

## Manual Control

If you need manual control, you can override in `extraConfig`:

```nix
extraConfig = {
  hardware.desktop = {
    enable = true;
    enableMsiSensors = false;  # Disable MSI sensors even on MSI hardware
  };
  
  # OR
  
  hardware.laptop = {
    enable = true;
    enableSystem76 = true;
    enablePangolinQuirks = false;  # Skip Pangolin-specific quirks
  };
}
```

## Migration from Old Modules

The old vendor-specific modules have been replaced:
- `hardware/msi.nix` → `hardware/desktop.nix` (with `enableMsiSensors`)
- `hardware/system76.nix` → `hardware/laptop.nix` (with `enableSystem76`)

No configuration changes needed - the new modules are automatically enabled based on your existing vendor settings.

See [`docs/HARDWARE_MODULE_REFACTOR.md`](../../docs/HARDWARE_MODULE_REFACTOR.md) for details.
