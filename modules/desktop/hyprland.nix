{
  lib,
  homeModules,
  pkgs,
  config,
  ...
}:
{
  imports = [ 
    ./greetd.nix 
  ];

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

    # Add system packages for utilities, graphics, and theming
    environment.systemPackages = with pkgs; [
      # System apps
      mate.mate-polkit
      wayvnc
      xwayland-satellite  
      brightnessctl    
      colloid-icon-theme
      adwaita-icon-theme
      papirus-icon-theme      
    ];  
    
    environment.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt6ct";
      GDK_SCALE = "1";
    };

    # Enable some homeManager stuff
    home-manager.sharedModules = with homeModules; [
      wm
      dankMaterialShell
    ];    
  };
}
