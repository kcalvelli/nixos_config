{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  # Define Cosmic options
  options.cosmic = {
    enable = lib.mkEnableOption "Enable Cosmic desktop environment";
  };

  # Configure Cosmic if enabled
  config = lib.mkIf config.cosmic.enable {

    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
    services.flatpak.enable = true;
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

    programs = {
      evince.enable = true;
      file-roller.enable = true;
      gnome-disks.enable = true;
      seahorse.enable = true;
      corectrl.enable = true;
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

      # Utilities
      qalculate-gtk

      # Graphics apps
      pinta
      shotwell

    ];

    # Enable some homeManager stuff
    home-manager.sharedModules = with inputs.self.homeModules; [
      tui
    ];
  };
}