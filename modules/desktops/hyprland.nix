{ lib, pkgs, homeModules, config, ... }:
let
  cfg = config.desktops.hyprland;
in
{
  options.desktops.hyprland = {
    enable = lib.mkEnableOption "Hyprland desktop environment with QuickShell";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    services = {
      displayManager.greetd = {
        enable = lib.mkDefault true;
        settings = {
          default_session = {
            command = ''${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd hyprland'';
            user = "";
          };
        };
      };

      gnome.gnome-keyring.enable = true;
      blueman.enable = true;
      power-profiles-daemon.enable = true;
      flatpak.enable = true;
    };

    hardware.bluetooth.enable = true;

    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        GTK_THEME = "adw-gtk3-dark";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "Hyprland";
        QT_QPA_PLATFORM = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };

      systemPackages = with pkgs; let
        hyprlandApps = [
          hyprland
          hyprpaper
          hypridle
          hyprlock
          hyprcursor
          quickshell
          swww
        ];

        coreDesktopApps = [
          waybar
          wofi
          wlogout
          grim
          slurp
          swappy
          wl-clipboard
          cliphist
          xdg-utils
          wluma
        ];

        productivityApps = [
          nautilus
          gnome-disk-utility
          gnome-system-monitor
          file-roller
          evince
          loupe
          gnome-weather
          gnome-calendar
        ];

        communicationApps = [
          fractal
          element-desktop
          thunderbird
        ];

        configurationTools = [
          nwg-look
          polkit_gnome
          dconf-editor
          kdeconnect
          pavucontrol
          networkmanagerapplet
          blueman
        ];
      in
        hyprlandApps
        ++ coreDesktopApps
        ++ productivityApps
        ++ communicationApps
        ++ configurationTools;
    };

    security.pam.services.hyprlock = {};

    programs = {
      seahorse.enable = true;
      kdeconnect.enable = true;
    };

    fonts.packages = with pkgs; [
      inter
      roboto
      noto-fonts
      noto-fonts-emoji
      nerd-fonts.fira-code
    ];

    networking.networkmanager.enable = true;

    home-manager.sharedModules = with homeModules; [
      hyprland
    ];
  };
}
