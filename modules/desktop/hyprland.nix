{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  # For this one, we will be using homeManager to manage Hyprland
  imports =
    [
      inputs.home-manager.nixosModules.default
    ];

  # Define Hyprland options
  options.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland compositor with illogical-impulse dotfiles";
  };

  # Configure Hyprland if enabled
  config = lib.mkIf config.hyprland.enable {  
    # Use hyprland configuration for Home Manager
    home-manager.sharedModules = with inputs.self.homeModules; [
      hyprland
    ];
  };  
}
