{
  # Define home modules for different setups

  flake = {
    homeModules = {
      plasma = ./plasma;
      cosmic = ./cosmic;
      workstation = ./profiles/workstation;
      laptop = ./profiles/laptop;
    };
  };
}
