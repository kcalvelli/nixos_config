{ config
, lib
, ...
}:
let
  cfg = config.greeter;
in
{
  options.greeter = {
    enable = lib.mkEnableOption "DankMaterialShell Greeter (greetd)";

    # DMS greeter supports niri/hyprland/sway; keep in sync with your usage
    compositor = lib.mkOption {
      type = lib.types.enum [ "niri" "hyprland" "sway" ];
      default = "niri";
      description = "Compositor launched by the greeter.";
    };

    # Match DMS module type (nullOr str). If null, DMS won't copy per-user files.
    configHome = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "User home directory to copy configurations for the greeter (e.g. /home/keith).";
    };
  };

  config = lib.mkIf cfg.enable {
    ##### Greeter (delegates to the upstream DMS greeter module you showed)
    programs.dankMaterialShell.greeter = {
      enable = true;
      compositor.name = cfg.compositor;
      configHome = cfg.configHome;
    };

    ##### GNOME Keyring (system)
    services.gnome.gnome-keyring.enable = true;

    security = {
      pam = {
        services = {
          greetd.enableGnomeKeyring = true;
          login.enableGnomeKeyring = true;
        };
      };
    };
  };
}
