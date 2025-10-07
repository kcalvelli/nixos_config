{ lib, config, ... }:
{
  # Import common configurations
  imports = [
    ../common
    ../../hyprland/laptop.nix
  ];
}
