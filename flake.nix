{
  description = "AxiOS";

  inputs = {
    # Make nixpkgs follow nixos-cosmic to avoid compiling cosmic
    #nixpkgs.follows = "nixos-cosmic/nixpkgs";

    # Uncomment the desired nixpkgs source
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";    
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

    # FlakeHub/Determinate
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";

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

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

    nix-gaming.url = "github:fufexan/nix-gaming";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };     

    # Enable when quickemu is broken in nixpkgs
    #quickemu.url = "https://flakehub.com/f/quickemu-project/quickemu/4.9.7.tar.gz";

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    zen-browser = {
      url = "https://flakehub.com/f/kbwhodat/zen-browser/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };

  outputs =
    inputs@{ nixpkgs, flake-parts, systems, ... }:

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
