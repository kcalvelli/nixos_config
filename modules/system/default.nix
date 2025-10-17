{ pkgs, ... }:
let
  # Import categorized package lists
  packages = import ./packages.nix { inherit pkgs; };
in
{
  # Import necessary modules
  imports = [
    ./local.nix
    ./nix.nix
    ./boot.nix
    ./printing.nix
    ./sound.nix
    ./bluetooth.nix
  ];

  # === System Packages ===
  # Organized by category in packages.nix for easier management
  environment.systemPackages =
    packages.core
    ++ packages.filesystem
    ++ packages.monitoring
    ++ packages.archives
    ++ packages.security
    ++ packages.nix;

  # Build smaller systems
  documentation.enable = false;
  documentation.nixos.enable = false;
  documentation.dev.enable = false;
  programs.command-not-found.enable = false;



}
