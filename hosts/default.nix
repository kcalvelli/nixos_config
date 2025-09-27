{ 
  inputs, 
  ... 
}: let
  # Define a function to create a NixOS system configuration
  nixosSystem =
    args:
    inputs.nixpkgs.lib.nixosSystem (
      {
        specialArgs = {
          #inherit inputs;
          selfModules = inputs.self.nixosModules;
          homeModules = inputs.self.homeModules;
          selfPkgs = inputs.self.packages;
          fh = inputs.fh.packages.aarch64-linux.default;
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
        inputs.determinate.nixosModules.default
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.vscode-server.nixosModules.default
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-pc-ssd  
        ./edge 
      ];
    };
    pangolin = nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        inputs.home-manager.nixosModules.default
        inputs.determinate.nixosModules.default
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.vscode-server.nixosModules.default
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        inputs.nixos-hardware.nixosModules.common-pc-laptop      
        ./pangolin 
      ];
    };
  };
}
