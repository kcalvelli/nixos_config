{
  # Define home modules for different setups
  flake = {
    homeModules = {
      workstation = ./workstation.nix;
      laptop = ./laptop.nix;
      tui = ./tui.nix;
      plasma = ./plasma.nix;
      cosmic = ./cosmic.nix;
    };
  };
}
