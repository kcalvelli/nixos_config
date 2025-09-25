{
  # Define home modules for different setups

  flake = {
    homeModules = {
      tui = ./tui.nix;
      plasma = ./plasma;
      cosmic = ./cosmic;
      workstation = ./profiles/workstation.nix;
      laptop = ./profiles/laptop.nix;
    };
  };
}
