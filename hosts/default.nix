{ inputs
, self
, ...
}:
let
  # Define a function to create a NixOS system configuration
  nixosSystem =
    args:
    inputs.nixpkgs.lib.nixosSystem (
      {
        specialArgs = {
          inherit inputs self;
          inherit (self) nixosModules; # NixOS modules
          inherit (self) homeModules; # Home Manager modules
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
        inputs.niri.nixosModules.niri
        inputs.dankMaterialShell.nixosModules.greeter
        inputs.home-manager.nixosModules.home-manager
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
        inputs.niri.nixosModules.niri
        inputs.dankMaterialShell.nixosModules.greeter
        inputs.home-manager.nixosModules.home-manager
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
