{ config, lib, ... }:
let
  cfg = config.services;
  domain = config.networking.hostName;
  tailnet = "taile0fb4.ts.net";
in
{
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
          --http-prefix=/ntopng
        '';
      };

      services.caddy.virtualHosts."${domain}.${tailnet}" = {
        extraConfig = ''
          @ntopRoot path /ntopng
          redir @ntopRoot /ntopng/ 301

          handle /ntopng/* {
            reverse_proxy http://127.0.0.1:3000
          }
        '';
      };
    })
  ];
}
