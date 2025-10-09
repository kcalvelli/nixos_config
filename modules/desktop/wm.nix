{
  lib,
  homeModules,
  pkgs,
  config,
  ...
}:
{
  imports = [ 
    ./hyprland.nix
    #./niri.nix
  ];

  # Define WM options
  options.wm = {
    enable = lib.mkEnableOption "Enable Wayland window managers";
  };

  # Configure wm if enabled
  config = lib.mkIf config.wm.enable {  

    # Greeter configuration:
    # - Defines a system group and user named "greeter" for use by the display manager greeter.
    # - The "greeter" user is a system user with its own home directory at /var/lib/dmsgreeter and uses bash as its shell.
    # - Enables the greetd service and sets the default session user to "greeter" as required by the DMS greeter module.
    # - Configures the dankMaterialShell greeter with the "niri" compositor and a hardcoded configHome.
    # - Enables the niri compositor program.
    users.groups.greeter = { };
    users.users.greeter = {
      isSystemUser = true;
      group        = "greeter";
      home         = "/var/lib/dmsgreeter";
      createHome   = true;
      shell        = pkgs.bashInteractive;
    };
  
    services.greetd.enable = true;
    # REQUIRED by the DMS greeter module’s assertion:
    services.greetd.settings.default_session.user = "greeter";
  
    programs = {
      dankMaterialShell.greeter = {
        enable = true;
        compositor.name = "niri";
        configHome = "/home/keith"; # Hardcoded for now
      };
      niri.enable = true;
    };    

    hyprland.enable = true;

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
