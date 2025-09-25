{
  config,
  lib,
  ...
}:
let
  cfg = config.services.hass;
  domain = config.networking.hostName;
  tailnet = "taile0fb4.ts.net";
in
{
  options.services.hass = {
    enable = lib.mkEnableOption "Home Assistant (with voice and reverse proxy)";
  };

  config = lib.mkIf cfg.enable {
    #############################
    # Home Assistant core
    #############################
    services =
      {
        home-assistant = {
          enable = true;

          # Keep HA behind Caddy; don't open 8123 to the LAN
          openFirewall = false;

          extraComponents = [
          "default_config"
          "frontend"
          "conversation"
          "media_source"
          "assist_pipeline"
          "mqtt"
          "matter"
          "thread"
          "tts"
          "google_translate"
          "ffmpeg"
          "cast"
          "wyoming"
          "tplink"
          "smartthings"
          "tuya"
          "rachio"
          "homekit"
          "homekit_controller"
          "sonos"
          "google"
          "google_photos"
          "google_maps"

          ];

          config = {
          homeassistant = { };

          http = {
            use_x_forwarded_for = true;
            trusted_proxies = [
              "127.0.0.1"
              "::1"
            ];
          };

          default_config = { };
          frontend = { };
          conversation = { };
          media_source = { };

          # Keep Google Translate TTS available (works immediately)
          tts = [
            {
              platform = "google_translate";
              language = "en";
              cache = true;
              time_memory = 300;
              service_name = "google_say";
            }
          ];

          # NOTE:
          # We intentionally omit 'stt:' and 'assist_pipeline:' YAML here.
          # After adding the two Wyoming integrations in the UI, create/set
          # the default pipeline via the HA UI so it references those providers.
        };
      };
        matter-server.enable = true;

        #mqtt.enable = true;
        #govee2mqtt = {
        #  enable = true;
        #  environmentFile = "/etc/govee2mqtt.env"; # Create this file with your Govee API key
        #};
      }
      // lib.mkIf cfg.enable {
        caddy = {
          enable = true;
          virtualHosts."${domain}.${tailnet}" = {
            extraConfig = ''
              encode gzip
              reverse_proxy http://127.0.0.1:8123
            '';
          };
        };
      };

    # let HA hear mDNS and SSDP broadcasts
    networking.firewall.allowedUDPPorts = [
      5353
      1900
    ];

    #############################
    # Wyoming Voice (always on)
    #############################
    virtualisation.oci-containers.containers = {
      wyoming-whisper = {
        image = "rhasspy/wyoming-whisper:latest";
        autoStart = true;
        # Map host 127.0.0.1:10300 -> container 10300
        ports = [ "127.0.0.1:10300:10300" ];
        # Persist models/cache between restarts (optional but recommended)
        volumes = [
          "/var/lib/wyoming/whisper:/data"
          "/var/cache/wyoming/hf:/root/.cache/huggingface"
        ];
        # Minimal, known-good args (no --port)
        cmd = [
          "--model"
          "small-int8"
          "--language"
          "en"
        ];
      };

      wyoming-piper = {
        image = "rhasspy/wyoming-piper:latest";
        autoStart = true;
        # Map host 127.0.0.1:10200 -> container 10200
        ports = [ "127.0.0.1:10200:10200" ];
        volumes = [
          "/var/lib/wyoming/piper:/data"
        ];
        # Minimal, known-good args (no --port)
        cmd = [
          "--voice"
          "en_US-lessac-medium"
        ];
      };

      wyoming-openwakeword = {
        image = "rhasspy/wyoming-openwakeword:latest";
        autoStart = true;
        # Bind to loopback only
        ports = [ "127.0.0.1:10400:10400" ];
        # Preload the default English model; you can add more later
        cmd = [
          "--preload-model"
          "ok_nabu"
        ];
        # Persist downloaded models
        volumes = [
          "/var/lib/wyoming/openwakeword:/data"
        ];
        extraOptions = [ "--pull=always" ];
      };
    };
  };
}
