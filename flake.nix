{
  description = "AxiOS";

  inputs = {
    #nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    #nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # FlakeHub/Determinate
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };

    systems = {
      url = "github:nix-systems/x86_64-linux";
    };

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };

    devshell = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/devshell";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    # For dev shells
    "zig-overlay".url = "github:mitchellh/zig-overlay";
    fenix.url = "github:nix-community/fenix";

    lazyvim = {
      url = "github:matadaniel/LazyVim-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty?ref=refs/tags/tip";
      inputs = {
        #flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Niri with DMS Shell
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.quickshell.follows = "quickshell";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fun with "AI" 
    nix-ai-tools.url = "github:numtide/nix-ai-tools";
  };

  outputs =
    inputs@{ flake-parts
    , systems
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      perSystem = { pkgs, system, ... }: {
        formatter = pkgs.nixpkgs-fmt;
        
        # ISO image package
        packages.iso = inputs.self.nixosConfigurations.installer.config.system.build.isoImage;
      };

      imports = [
        ./pkgs
        ./hosts
        ./modules
        ./home
        ./devshells.nix
      ];
    };
}
# Trigger CI
