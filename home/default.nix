{ ...
}:
{
  # Define home modules for different setups
  flake = {
    homeModules = {
      wayland = ./desktops;
      workstation = ./profiles/workstation;
      laptop = ./profiles/laptop.nix;
    };
  };
}
