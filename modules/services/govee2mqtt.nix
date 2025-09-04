{ 
  config, 
  lib, 
  pkgs, 
  ... 
}:
let
  cfg = config.services.govee2mqtt;
in {
  options.services.govee2mqtt = {
    enable = lib.mkEnableOption "govee2mqtt bridge";
    mqtt.host = lib.mkOption { type = lib.types.str; default = "127.0.0.1"; };
    mqtt.port = lib.mkOption { type = lib.types.int; default = 1883; };
    # Path to an env file you'll create manually after deploy (not tracked in git).
    envFile = lib.mkOption { type = lib.types.path; default = "/etc/opt/govee2mqtt.env"; };
    image = lib.mkOption { type = lib.types.str; default = "ghcr.io/wez/govee2mqtt:latest"; };
  };

  config = lib.mkIf cfg.enable {
    # Use Podman-backed oci-containers (works fine alongside the rest of your setup)
    virtualisation.oci-containers.containers.govee2mqtt = {
      image = cfg.image;
      autoStart = true;
      hostname = "govee2mqtt";
      # Host networking is simplest; HA and broker can see it on localhost.
      extraOptions = [ "--network=host" ];
      environment = {
        MQTT_HOST = cfg.mqtt.host;
        MQTT_PORT = toString cfg.mqtt.port;
        # The app can also use email/password and/or API key (optional) – supplied via env file below.
        # GOVEE_EMAIL, GOVEE_PASSWORD, GOVEE_API_KEY are read from EnvironmentFile.
      };
    };

    # Feed secrets via a systemd EnvironmentFile you create by hand post-install.
    systemd.services."podman-govee2mqtt".serviceConfig = {
      EnvironmentFile = cfg.envFile;
      # Start after network and the MQTT broker so it can connect cleanly.
      After = [ "network-online.target" "mosquitto.service" ];
      Requires = [ "network-online.target" ];
      Wants = [ "mosquitto.service" ];
    };

    # Ensure broker is up (if you're using mosquitto in NixOS)
    # services.mosquitto.enable = lib.mkDefault true;
  };
}