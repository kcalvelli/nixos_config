{inputs, ...}: let
  # Define the home-manager configuration
  hmConfig = pkgs: module:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs;
      };
    };
in {
  # Define home modules for different setups
  flake.homeModules.workstation = ./workstation.nix;
  flake.homeModules.laptop = ./laptop.nix;
  flake.homeModules.tui = ./tui.nix;
}
