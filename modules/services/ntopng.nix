{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services;
  domain = config.networking.hostName;
  tailnet = "taile0fb4.ts.net";
in {
  options = {
    services.ntop = {
      enable = lib.mkEnableOption "ntop";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.ntop.enable {
      services.ntopng = {
        enable = true;
        extraConfig = ''
          --geoip-db-dir=/home/keith/.config/ntopng/geoip
        '';
      };

      services.caddy.virtualHosts."${domain}.${tailnet}" = {
        extraConfig = ''
          reverse_proxy http://localhost:3000
          encode gzip
        '';
      };
    })
  ];
}
