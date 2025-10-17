{ lib, pkgs, config, ... }:
{
  # Import Cosmic configuration
  imports = [
    ./cosmic.nix
    ./wayland
    #./plasma.nix
  ];

  cosmic.enable = false;
  wayland.enable = true;

  # === Wayland Environment Variables ===
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      OZONE_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
  };

  # === Desktop Services ===
  # Services needed by all WMs/DEs
  services = {
    udisks2.enable = true;
    system76-scheduler.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    upower.enable = true;
    libinput.enable = true;
    acpid.enable = true;
    power-profiles-daemon.enable = lib.mkDefault (
      !config.hardware.system76.power-daemon.enable
    );
  };

  # === Desktop Programs ===
  programs = {
    corectrl.enable = true;
    kdeconnect.enable = true;
    dconf.enable = true;
    localsend = {
      enable = true;
      openFirewall = true;
    };
  };

  # === XDG Portal Configuration ===
  xdg = {
    mime.enable = true;
    icons.enable = true;
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
      config.common.default = [ "gnome" "gtk" ];
    };
  };

  # === Desktop Applications ===
  # Apps common to all WMs/DEs (system-level installation required)
  environment.systemPackages = with pkgs; [
    # === VPN Applications ===
    protonvpn-gui
    protonvpn-cli

    # === Streaming and Recording ===
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-gstreamer
        obs-move-transition
        obs-backgroundremoval
      ];
    })
  ];
}
