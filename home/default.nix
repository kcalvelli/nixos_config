{ ...
}:
{
  # Define home modules for different setups
  flake = {
    homeModules = {
      plasma = ./desktops/plasma.nix;
      cosmic = ./desktops/cosmic.nix;
      wayland = ./desktops/wayland;
      workstation = ./profiles/workstation;
      laptop = ./profiles/laptop.nix;
    };
  };
}
