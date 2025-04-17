{
  inputs,
  lib,
  pkgs,
  ...
}: {
  # Import Cosmic configuration
  imports = [./cosmic.nix];
  cosmic.enable = true;

  # Services needed by all WMs/DEs
  services = {
    flatpak.enable = true;
    udisks2.enable = true;
    system76-scheduler.enable = true;
  };

  # Programs needed by all WMs/DEs
  programs = {
    evince.enable = true;
    file-roller.enable = true;
    gnome-disks.enable = true;
    seahorse.enable = true;
    corectrl = {
      enable = true;
      gpuOverclock = {
        enable = true;
      };
    };
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
    # System apps
    baobab
    adw-gtk3
    gnome-firmware

    # Utilities
    qalculate-gtk

    # Graphics apps
    pinta
    shotwell

    # Browser
    brave
    # Enable to test new features in Brave
    # inputs.self.packages.${pkgs.system}.brave-browser-nightly

    # Sync clients
    rclone
    nextcloud-client

    # Proton apps
    protonvpn-gui
    protonvpn-cli

    # Social apps
    discord

    # Streaming/Recording
    #(wrapOBS {
    #  plugins = with obs-studio-plugins; [ wlrobs obs-gstreamer obs-move-transition obs-backgroundremoval ];
    #})
  ];

  # Fonts
  fonts.packages = with pkgs; [
    inter
    nerd-fonts.fira-code
    nerd-fonts.noto
  ];
}
