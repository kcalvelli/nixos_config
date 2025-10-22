# Host: HOSTNAME (Brief description)
# Copy this file to HOSTNAME.nix and customize
{ lib, ... }:
{
  hostConfig = {
    # Basic identification
    hostname = "HOSTNAME";  # Must match filename without .nix
    system = "x86_64-linux"; # or "aarch64-linux" for ARM
    formFactor = "desktop"; # desktop, laptop, or server (for documentation)
    
    # Hardware configuration
    hardware = {
      vendor = null;  # Options: "msi" (desktop), "system76" (laptop), or null for generic
      cpu = "amd";    # "amd" or "intel" (for nixos-hardware modules)
      gpu = "amd";    # "amd", "nvidia", or "intel"
      hasSSD = true;  # Enables SSD optimizations from nixos-hardware
      isLaptop = false; # Adds laptop-specific hardware modules
    };
    
    # NixOS modules to enable (all are optional)
    modules = {
      system = true;        # Core system configuration (boot, nix, etc.)
      desktop = true;       # Desktop environment support
      development = true;   # Development tools
      services = false;     # Server services (Caddy, Home Assistant, etc.)
      graphics = true;      # GPU drivers and graphics support
      networking = true;    # Network configuration
      users = true;         # User management
      virt = false;         # Virtualization (libvirt, containers)
      gaming = false;       # Gaming support (Steam, etc.)
    };
    
    # Services to enable (optional)
    services = {
      # caddy-proxy.enable = true;
      # openwebui.enable = true;
      # ntop.enable = true;
      # hass.enable = true;
      # mqtt.enable = true;
    };
    
    # Virtualization configuration (optional)
    virt = {
      # libvirt.enable = true;
      # containers.enable = true;
    };
    
    # Home-manager profile
    # Options: "workstation" or "laptop" (or create custom in home/profiles/)
    homeProfile = "workstation";
    
    # Optional: Extra NixOS configuration
    extraConfig = {
      # Example: time.hardwareClockInLocalTime = true;
      
      # If not using diskConfigPath below, you can define disks here:
      # fileSystems."/" = {
      #   device = "/dev/disk/by-uuid/...";
      #   fsType = "ext4";
      # };
      # fileSystems."/boot" = {
      #   device = "/dev/disk/by-uuid/...";
      #   fsType = "vfat";
      # };
    };
    
    # Disk configuration path (OPTIONAL)
    # If omitted, you must define fileSystems in extraConfig above
    # diskConfigPath = ./HOSTNAME/disks.nix;
  };
}
