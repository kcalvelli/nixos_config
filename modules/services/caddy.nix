{ config, lib, ... }:
let
  cfg = config.services.caddy-proxy;
in
{
  # Define options for caddy-proxy service
  options = {
    services.caddy-proxy = {
      enable = lib.mkEnableOption "Enable caddy-proxy service";
    };
  };

  # Configuration for caddy-proxy service
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
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
