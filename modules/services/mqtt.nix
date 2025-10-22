{ config, lib, ... }:
let
  cfg = config.services;
in
{
  options.services.mqtt.enable = lib.mkEnableOption "Local Mosquitto MQTT broker (localhost only)";

  config = lib.mkIf cfg.mqtt.enable {
    services.mosquitto = {
      enable = true;
      listeners = [
        {
          port = 1883;
          address = "127.0.0.1"; # local only
          settings.allow_anonymous = true; # easy first-run; can harden later
        }
        {
          port = 1883;
          address = "::1";
          settings.allow_anonymous = true;
        }
      ];
    };
    # No firewall ports: local-only
  };
}
