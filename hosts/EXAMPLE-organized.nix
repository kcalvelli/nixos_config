# Example: Organized host with separate disk file
# Cleaner for complex setups or when sharing disk configs
{ lib, ... }:
{
  hostConfig = {
    hostname = "organized-workstation";
    system = "x86_64-linux";
    
    hardware = {
      vendor = "msi";
      cpu = "amd";
      gpu = "amd";
      hasSSD = true;
      isLaptop = false;
    };
    
    modules = {
      system = true;
      desktop = true;
      development = true;
      graphics = true;
      networking = true;
      users = true;
      virt = true;
      gaming = true;
      services = true;
    };
    
    services = {
      caddy-proxy.enable = true;
    };
    
    virt = {
      libvirt.enable = true;
      containers.enable = true;
    };
    
    homeProfile = "workstation";
    
    extraConfig = {
      # Example: Enable MSI sensor support if using MSI motherboard
      # hardware.desktop.enableMsiSensors = true;
      time.hardwareClockInLocalTime = true;
    };
    
    # Disk config in separate file (requires organized-workstation/ directory)
    diskConfigPath = ./organized-workstation/disks.nix;
  };
}
