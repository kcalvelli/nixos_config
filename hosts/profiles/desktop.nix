{ lib, ... }:
{
  # Default desktop configuration
  config = {
    # Typically desktops want gaming, virtualization, etc.
    virt = lib.mkDefault {
      libvirt.enable = true;
      containers.enable = true;
    };
  };
}
