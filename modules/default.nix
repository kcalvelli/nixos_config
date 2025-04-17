{...}: {
  # Define all the modules that are available in the system
  flake.nixosModules = {
    system = ./system;
    desktop = ./desktop;
    development = ./development;
    gaming = ./gaming;
    hardware = ./hardware;
    graphics = ./graphics;
    networking = ./networking;
    services = ./services;
    users = ./users;
    virt = ./virtualisation;
    system76 = ./hardware/system76.nix;
    msi = ./hardware/msi.nix;
  };
}
