{ lib
, pkgs
, config
, ...
}:
{
  # Import Cosmic configuration
  imports = [
    ./cosmic.nix
    ./wayland
    #./plasma.nix
  ];

  cosmic.enable = false;
  wayland.enable = true;

  # Wayland environment always
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      OZONE_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
  };

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

  programs = {
    corectrl.enable = true;
    kdeconnect.enable = true;
    dconf.enable = true;
    localsend = {
      enable = true;
      openFirewall = true;
    };
  };

  xdg = {
    mime.enable = true;
    icons.enable = true;
    portal = {
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  # Desktop apps common to all WMs/DEs
  environment.systemPackages = with pkgs; [
    # VPN apps
    protonvpn-gui
    protonvpn-cli

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
}
