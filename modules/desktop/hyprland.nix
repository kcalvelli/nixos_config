{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  # Import the illogical-impulse Hyprland dotfiles module
  imports = [
    inputs.illogical-impulse.homeManagerModules.default
  ];

  # Define Hyprland options
  options.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland compositor with illogical-impulse dotfiles";
  };

  # Configure Hyprland if enabled
  config = lib.mkIf config.hyprland.enable {
    illogical-impulse = {
      # Enable the dotfiles suite
      enable = true;

      hyprland = {
        # Use customized Hyprland build
        package = hypr.hyprland;
        xdgPortalPackage = hypr.xdg-desktop-portal-hyprland;

        # Enable Wayland ozone
        ozoneWayland.enable = true;
      };

      # Dotfiles configurations
      dotfiles = {
        anyrun.enable = true;
        fish.enable = true;
        kitty.enable = true;
      };
    };
  };
}