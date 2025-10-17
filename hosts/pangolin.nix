# Host: pangolin (System76 laptop)
{ lib, ... }:
{
  hostConfig = {
    # Basic identification
    hostname = "pangolin";
    system = "x86_64-linux";
    formFactor = "laptop";
    
    # Hardware configuration
    hardware = {
      vendor = "system76";
      cpu = "amd";
      gpu = "amd";
      hasSSD = true;
      isLaptop = true;
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
      gaming = false; # Laptops might not need gaming
    };
    
    # Virtualization
    virt = {
      libvirt.enable = true;
      containers.enable = true;
    };
    
    # Home-manager profile
    homeProfile = "laptop";
    
    # Optional: Extra NixOS configuration
    extraConfig = {
      # Enable System76 hardware support
      hardware.system76.enable = true;
    };
    
    # Disk configuration path
    diskConfigPath = ./pangolin/disks.nix;
  };
}
