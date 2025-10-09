{
  lib,
  pkgs,
  config,
  ...
}:
{
  # Define Hyprland options
  options.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland window manager";
  };

  # Configure Hyprland if enabled
  config = lib.mkIf config.hyprland.enable {  
    programs = {
      hyprland.enable = true;
      xwayland.enable = true;     
    };   
  };
}
