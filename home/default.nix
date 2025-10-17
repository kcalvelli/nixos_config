{ ...
}:
{
  # Define home modules for different setups
  flake = {
    homeModules = {
      wayland = ./desktops/wayland;
      workstation = ./profiles/workstation;
      laptop = ./profiles/laptop.nix;
    };
  };
}
