{ lib
, homeModules
, pkgs
, config
, ...
}:
{
  imports = [
    #./hyprland.nix
    ./niri.nix
    ./greeter.nix
  ];

  # Define Wayland options
  options.wayland = {
    enable = lib.mkEnableOption "Enable Wayland compisitors and related services";
  };

  # Configure wayland if enabled
  config = lib.mkIf config.wayland.enable {
    # Enable what we use
    greeter = {
      enable = true;
      compositor = "niri"; # or "hyprland"
      configHome = "/home/keith";
    };
    #hyprland.enable = true;
    niri.enable = true;

    programs = {
      xwayland.enable = true;
      nautilus-open-any-terminal.enable = true;
      nautilus-open-any-terminal.terminal = "ghostty";
      evince.enable = true;
      file-roller.enable = true;
      gnome-disks.enable = true;
      seahorse.enable = true;
    };

    services = {
      gnome = {
        sushi.enable = true;
      };
    };

    # Add system packages for utilities, graphics, and theming
    environment.systemPackages = with pkgs; [
      # System apps
      mate.mate-polkit
      wayvnc
      xwayland-satellite
      brightnessctl
      colloid-icon-theme
      adwaita-icon-theme
      papirus-icon-theme

      # File manager
      nautilus
      code-nautilus
    ];

    environment.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt6ct";
      #GDK_SCALE = "1";
    };

    # Enable some homeManager stuff
    home-manager.sharedModules = with homeModules; [
      wayland
    ];
  };
}
