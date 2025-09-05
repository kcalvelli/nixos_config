{
  inputs,
  ...
}:
{
  # Import necessary modules
  imports = [
    ./disks.nix
    inputs.home-manager.nixosModules.default
  ]
  ++ (with inputs.self.nixosModules; [
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
  home-manager.sharedModules = with inputs.self.homeModules; [ laptop ];

  # Define Hostname
  networking = {
    hostName = "pangolin"; # Define your hostname.
  };
}
