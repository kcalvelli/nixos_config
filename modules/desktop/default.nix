{
  lib,
  pkgs,
  ...
}:
{
  # Import Cosmic configuration
  imports = [
    ./cosmic.nix
    #./plasma.nix
  ];
  cosmic.enable = true;
  #plasma.enable = lib.mkDefault true;
  # Disabling Cosmic for now, as it is not ready yet
  # Uncomment the following lines to enable Cosmic when ready
  #specialisation.cosmic.configuration = {
  #  cosmic.enable = true;
  #  plasma.enable = lib.mkForce false;
  #};

  # Services needed by all WMs/DEs
  services = {
    udisks2.enable = true;
    system76-scheduler.enable = true;
  };

  # Environment variables
  environment = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
  };

  # Desktop apps common to all WMs/DEs
  environment.systemPackages = with pkgs; [

    # Browser
    brave
    # Enable to test new features in Brave
    #selfPkgs.${pkgs.system}.brave-browser-nightly

    # Note-taking
    obsidian

    # Proton apps
    protonvpn-gui
    protonvpn-cli

    # Social apps
    discord

    # Markdown Editor
    typora

    # File syncing
    nextcloud-client

    # Streaming/Recording
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-gstreamer
        obs-move-transition
        obs-backgroundremoval
      ];
    })
  ];

  # Fonts
  fonts.packages = with pkgs; [
    inter
    nerd-fonts.fira-code
    nerd-fonts.noto
  ];
}
