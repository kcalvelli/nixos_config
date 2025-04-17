{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services;
  hostName = config.networking.hostName;
  tailnet = "taile0fb4.ts.net";
in {
  # Define options for caddy-proxy service
  options = {
    services.caddy-proxy = {
      enable = lib.mkEnableOption "Enable caddy-proxy service";
    };
  };

  # Configuration for caddy-proxy service
  config = lib.mkMerge [
    (lib.mkIf cfg.caddy-proxy.enable {
      services.caddy = {
        enable = true;
        globalConfig = ''
          servers {
            metrics
          }
        '';
      };
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    })
  ];
}
