{ lib, inputs, pkgs, config, ... }:

{
  # Import Cosmic module
  imports = [ inputs.nixos-cosmic.nixosModules.default ];

  # Define Cosmic options
  options.cosmic = {
    enable = lib.mkEnableOption "Enable Cosmic desktop environment";
  };

  # Configure Cosmic if enabled
  config = lib.mkIf config.cosmic.enable {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;

    environment.systemPackages = with pkgs; [
      andromeda
      cosmic-ext-applet-clipboard-manager
      #cosmic-ext-applet-emoji-selector
      #cosmic-ext-calculator
      examine
      forecast
      observatory
      #tasks
      cosmic-ext-tweaks
      cosmic-player
      cosmic-reader
      #stellarshot
      # Overlay of networkmanagerapplet that does not include appindicator
      inputs.self.packages.${pkgs.system}.networkmanagerapplet
    ];

    environment.sessionVariables = {
      COSMIC_DATA_CONTROL_ENABLED = 1;
    };
  };
}
