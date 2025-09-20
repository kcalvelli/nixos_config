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
      desktopManager.cosmic.enable = true;
      displayManager.cosmic-greeter.enable = true;
      flatpak.enable = true;
    };

    environment.sessionVariables = {
      COSMIC_DATA_CONTROL_ENABLED = 1;
      QT_QPA_PLATFORMTHEME = "gnome";            # route Qt theming via GNOME
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # let Qt use server-side decos on Wayland
      # Optional: prefer Wayland, fall back to XWayland if needed
      QT_QPA_PLATFORM = "wayland;xcb";
    };

    programs = {
      evince.enable = true;
      file-roller.enable = true;
      gnome-disks.enable = true;
      seahorse.enable = true;
      corectrl.enable = true;

      # Open Kdeconnect ports
      kdeconnect.enable = true;      
    };

    environment.systemPackages = with pkgs; [
      forecast
      cosmic-ext-tweaks
      cosmic-ext-calculator
      cosmic-player

      # Overlay of networkmanagerapplet that does not include appindicator
      inputs.self.packages.${pkgs.system}.networkmanagerapplet
      inputs.self.packages.${pkgs.system}.cosmic-ext-applet-clipboard-manager
      inputs.self.packages.${pkgs.system}.examine
      # System apps
      baobab
      adw-gtk3
      gnome-firmware

      # For Qt apps to look better in Cosmic
      qgnomeplatform
      qgnomeplatform-qt6
      adwaita-qt6
      gsettings-desktop-schemas
      adwaita-icon-theme
      
      # Utilities
      qalculate-gtk

      # Graphics apps
      pinta
      shotwell
    ];

    # Enable some homeManager stuff
    home-manager.sharedModules = with inputs.self.homeModules; [
      cosmic
    ];    
  };
}
