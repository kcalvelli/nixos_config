{
  lib,
  inputs,
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
  
    programs = {
      #evince.enable = true;
      file-roller.enable = true;
      gnome-disks.enable = true;
      seahorse.enable = true;
      corectrl.enable = true;    
      kdeconnect = {
        enable = true;
        package = pkgs.valent;
      };
    };

    environment.systemPackages = with pkgs; [

      # Overlay of networkmanagerapplet that does not include appindicator
      inputs.self.packages.${pkgs.system}.networkmanagerapplet
      inputs.self.packages.${pkgs.system}.cosmic-ext-applet-clipboard-manager
      
      # System apps
      baobab
      adw-gtk3
      gnome-firmware
      
      # Utilities
      qalculate-gtk

      # Graphics apps
      pinta
      shotwell

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
    home-manager.sharedModules = with inputs.self.homeModules; [
      cosmic
    ];    
  };
}
