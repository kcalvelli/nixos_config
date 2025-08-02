{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  # Define Cosmic options
  options.plasma = {
    enable = lib.mkEnableOption "Enable Plasma desktop environment";
  };

  # Configure Plasma if enabled
  config = lib.mkIf config.cosmic.enable {

    services.xserver.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.enable = true;
    services.displaymanage.sddm.wayland.enable = true;
    services.flatpak.enable = true;    

    environment.systemPackages = with pkgs; [

    ];

    # Enable some homeManager stuff
    home-manager.sharedModules = with inputs.self.homeModules; [
      tui
    ];
  };
}