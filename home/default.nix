{
  inputs,
  ...   
}:
{
  # Define home modules for different setups
  flake = {
    homeModules = {
      plasma = ./plasma;
      cosmic = ./cosmic;
      wm = ./wm;
      workstation = ./profiles/workstation;
      laptop = ./profiles/laptop;
    };
  };
}
