{
  lib,
  pkgs,
  myPkgs,
  ...
}:
{
  # Import Cosmic configuration
  imports = [
    ./cosmic.nix
    ./hyprland.nix
    #./plasma.nix
  ];

  cosmic.enable = false;
  hyprland.enable = true;
  #plasma.enable = lib.mkDefault true;
  # Disabling Cosmic for now, as it is not ready yet
  # Uncomment the following lines to enable Cosmic when ready
  #specialisation.cosmic.configuration = {
  #  cosmic.enable = true;
  #  plasma.enable = lib.mkForce false;
  #};

  # Wayland environment always
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL             = "1";
      OZONE_PLATFORM             = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
  };

  # programs = {
  #   dconf.enable = true;
  #   gnupg.agent = {
  #     enable = true;
  #     enableSSHSupport = false;
  #     pinentryPackage = pkgs.pinentry-curses;
  #   };    
  # };

  # Services needed by all WMs/DEs
  services = {
    udisks2.enable = true;
    system76-scheduler.enable = true;
    dbus.packages = [ pkgs.gcr ];
    gvfs.enable = true;
    flatpak.enable = true;
    gnome = {
      gnome-keyring = {
        enable = true;
      };
    };
    fwupd.enable = true;
  };
  
  programs = {
    evince.enable = true;
    file-roller.enable = true;
    gnome-disks.enable = true;
    seahorse.enable = true;
    corectrl.enable = true;    
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
