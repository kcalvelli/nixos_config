{ 
  pkgs, 
  lib,
  config,
  ... 
}:
lib.mkIf config.hyprland.enable {
  # Dedicated system user for the greeter
  users.groups.greeter = { };
  users.users.greeter = {
    isSystemUser = true;
    group        = "greeter";
    home         = "/var/lib/dmsgreeter";
    createHome   = true;
    shell        = pkgs.bashInteractive;
  };

  services.greetd.enable = true;
  # REQUIRED by the DMS greeter module’s assertion:
  services.greetd.settings.default_session.user = "greeter";

  programs = {
    dankMaterialShell.greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = "/home/keith"; # Hardcoded for now
    };
    niri.enable = true;
  };


}