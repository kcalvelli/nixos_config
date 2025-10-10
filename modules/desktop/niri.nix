{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  # Define Hyprland options
  options.niri = {
    enable = lib.mkEnableOption "Enable Niri";
  };

  # Configure Hyprland if enabled
  config = lib.mkIf config.niri.enable {  
    programs = {
      niri = {
        enable = true;  
        package = pkgs.niri-unstable; 
      };
    };  
  };
}
