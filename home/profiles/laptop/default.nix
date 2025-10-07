{ lib, config, ... }:
{
  # Import common configurations
  imports = [
    ../common
    (lib.mkIf (config.wayland.windowManager.hyprland.enable or false) ../../hyprland/laptop.nix)
  ];
}
