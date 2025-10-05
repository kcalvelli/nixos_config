{
  nixosModules,
  homeModules,
  ...
}:
{
  # Import necessary modules
  imports = [
    ./disks.nix
  ]
  ++ (with nixosModules; [
    system
    desktop
    development
    services
    graphics
    system76
    networking
    users
    virt
  ]);

  # Enable system76 hardware support
  hardware.system76.enable = true;

  # Enable virtualization
  virt.libvirt.enable = true;
  virt.containers.enable = true;

  # Use laptop configuration for Home Manager
  home-manager.sharedModules = with homeModules; [ laptop lazyvim ];

  # Define Hostname
  networking = {
    hostName = "pangolin"; # Define your hostname.
  };
}
