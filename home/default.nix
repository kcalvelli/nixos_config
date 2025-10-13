{ inputs
, ...
}:
{
  # Define home modules for different setups
  flake = {
    homeModules = {
      plasma = ./plasma;
      cosmic = ./cosmic;
      wayland = ./wayland;
      workstation = ./profiles/workstation;
      laptop = ./profiles/laptop;
    };
  };
}
