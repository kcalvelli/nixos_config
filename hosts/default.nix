{ inputs, ... }:
let
  # Define a function to create a NixOS system configuration
  nixosSystem =
    args:
    inputs.nixpkgs.lib.nixosSystem (
      {
        specialArgs = {
          inherit inputs;
        };
      }
      // args
    );
in
{
  flake.nixosConfigurations = {
    edge = nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        inputs.home-manager.nixosModules.default
        ./edge 
      ];
    };
    pangolin = nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        inputs.home-manager.nixosModules.default
        ./pangolin 
      ];
    };
  };
}
