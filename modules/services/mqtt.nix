{ 
  config, 
  lib, 
  pkgs, 
  ... }:
let cfg = config.services;
in {
  options.services.mqtt.enable = lib.mkEnableOption "Local Mosquitto MQTT broker (localhost only)";

  config = lib.mkIf cfg.mqtt.enable {
    services.govee2mqtt = {
      enable = true;
      mqtt.host = "127.0.0.1";
      mqtt.port = 1883; 
      envFile = "/etc/opt/govee2mqtt.env";
    };
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
