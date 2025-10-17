{ lib, ... }:
{
  # Default laptop configuration
  config = {
    # Laptops typically want power management
    virt = lib.mkDefault {
      libvirt.enable = true;
      containers.enable = true;
    };
    
    # Battery optimization can go here
  };
}
