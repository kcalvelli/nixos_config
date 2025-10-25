# Host: edge (Desktop workstation)
{ lib, ... }:
{
  hostConfig = {
    # Basic identification
    hostname = "edge";
    system = "x86_64-linux";
    formFactor = "desktop"; # desktop, laptop, or server
    
    # Hardware configuration
    hardware = {
      vendor = "msi"; # Options: msi, system76, or null for generic
      cpu = "amd";    # For nixos-hardware modules
      gpu = "amd";    # For nixos-hardware modules
      hasSSD = true;  # For nixos-hardware SSD optimizations
      isLaptop = false;
    };
    
    # NixOS modules to enable
    modules = {
      system = true;
      desktop = true;
      development = true;
      services = true;
      graphics = true;
      networking = true;
      users = true;
      virt = true;
      gaming = true;
    };
    
    # Services to enable
    services = {
      caddy-proxy.enable = true;
      # openwebui.enable = false;
      # ntop.enable = false;
      # hass.enable = false;
    };
    
    # Virtualization
    virt = {
      libvirt.enable = true;
      containers.enable = true;
    };
    
    # Home-manager profile (from home/profiles/)
    homeProfile = "workstation";
    
    # Optional: Extra NixOS configuration
    extraConfig = {
      # Dual boot with Windows requires local time
      time.hardwareClockInLocalTime = true;
      
      # Enable secure boot (already set up on this system)
      boot.lanzaboote.enableSecureBoot = true;
    };
    
    # Disk configuration path
    diskConfigPath = ./edge/disks.nix;
  };
}
