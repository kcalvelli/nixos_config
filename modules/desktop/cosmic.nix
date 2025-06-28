{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  # Import the Cosmic desktop environment module
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  # Define Cosmic options
  options.cosmic = {
    enable = lib.mkEnableOption "Enable Cosmic desktop environment";
  };

  # Configure Cosmic if enabled
  config = lib.mkIf config.cosmic.enable {

    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

    environment.systemPackages = with pkgs; [
      forecast
      cosmic-ext-tweaks
      cosmic-ext-calculator
      cosmic-player
      cosmic-ext-applet-clipboard-manager
      observatory
      examine
      # Overlay of networkmanagerapplet that does not include appindicator
      inputs.self.packages.${pkgs.system}.networkmanagerapplet
      #inputs.self.packages.${pkgs.system}.cosmic-ext-applet-clipboard-manager
      #inputs.self.packages.${pkgs.system}.observatory
      #inputs.self.packages.${pkgs.system}.examine
    ];

    #systemd.packages = [ pkgs.observatory ];
    #systemd.services.monitord.wantedBy = [ "multi-user.target" ];
  };
}