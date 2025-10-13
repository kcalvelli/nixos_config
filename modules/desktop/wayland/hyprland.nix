{ lib
, config
, ...
}:
{
  # Define Hyprland options
  options.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
  };

  # Configure Hyprland if enabled
  config = lib.mkIf config.hyprland.enable {
    programs = {
      hyprland.enable = true;
    };
  };
}
