{
  # Define all the modules that are available in the system
  flake.nixosModules = {
    system = ./system;
    desktop = ./desktop;
    development = ./development;
    hardware = ./hardware;
    graphics = ./graphics;
    networking = ./networking;
    services = ./services;
    users = ./users;
    virt = ./virtualisation;
    desktopHardware = ./hardware/desktop.nix;
    laptopHardware = ./hardware/laptop.nix;
    gaming = ./gaming;
  };
}
