# Example: Simple host with inline disk configuration
# No directory needed - everything is in this one file!
{ lib, ... }:
{
  hostConfig = {
    hostname = "simple-laptop";
    system = "x86_64-linux";
    
    hardware = {
      vendor = null;  # Generic hardware
      cpu = "intel";
      gpu = "intel";
      hasSSD = true;
      isLaptop = true;
    };
    
    modules = {
      system = true;
      desktop = true;
      development = true;
      graphics = true;
      networking = true;
      users = true;
      virt = false;
      gaming = false;
      services = false;
    };
    
    homeProfile = "laptop";
    
    # Everything in one place - no external files needed!
    extraConfig = {
      # Disk configuration defined inline
      fileSystems."/" = {
        device = "/dev/disk/by-uuid/12345678-1234-1234-1234-123456789abc";
        fsType = "ext4";
        options = [ "noatime" "nodiratime" ];
      };
      
      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/ABCD-1234";
        fsType = "vfat";
      };
      
      swapDevices = [
        { device = "/dev/disk/by-uuid/87654321-4321-4321-4321-cba987654321"; }
      ];
    };
    
    # No diskConfigPath needed when defined in extraConfig!
  };
}
