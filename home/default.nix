{
  # Define home modules for different setups

  flake = {
    homeModules = {
      plasma = ./plasma;
      cosmic = ./cosmic;
      hyprland = ./hyprland;
      workstation = ./profiles/workstation;
      laptop = ./profiles/laptop;
    };
  };
}
