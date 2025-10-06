{
  lib,
  myPkgs,
  homeModules,
  pkgs,
  config,
  ...
}:
{
  # Define Cosmic options
  options.cosmic = {
    enable = lib.mkEnableOption "Enable Cosmic desktop environment";
  };

  # Configure Cosmic if enabled
  config = lib.mkIf config.cosmic.enable {

    services = {
      desktopManager.cosmic = {
        enable = true;
        xwayland.enable = true;
      };
      displayManager.cosmic-greeter.enable = true;
      flatpak.enable = true;
    };

    environment.sessionVariables = {
      COSMIC_DATA_CONTROL_ENABLED = 1;
    };

    environment.systemPackages = with pkgs; [

      # Overlay of networkmanagerapplet that does not include appindicator
      myPkgs.networkmanagerapplet
      myPkgs.cosmic-ext-applet-clipboard-manager

      # System apps
      adw-gtk3
      
      # Utilities
      qalculate-gtk

      # Extra Cosmic apps
      cosmic-reader # pdf viewer
      cosmic-ext-ctl
      cosmic-applibrary
      forecast
      cosmic-ext-tweaks
      cosmic-ext-calculator
      cosmic-player    
      examine  
    ];

    # Enable some homeManager stuff
    home-manager.sharedModules = with homeModules; [
      cosmic
    ];    
  };
}
