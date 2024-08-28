{
  description = "AxiOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-24.05";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };

    flake-utils.inputs.systems.follows = "systems";

    systems.url = "github:nix-systems/x86_64-linux";

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };

    devshell = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/devshell";
    };

    flake-utils.url = "github:numtide/flake-utils";

    lanzaboote.url = "github:nix-community/lanzaboote";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      #url = "github:drakon64/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
 
  };

  outputs =
    inputs@{
      flake-parts,
      systems,
      zen-browser,
      ...
    }:

    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      imports = [
        ./pkgs
        ./hosts
        ./modules
        ./home
      ];     
    };
}
