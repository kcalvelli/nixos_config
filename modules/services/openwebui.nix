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
    services.openwebui = {
      enable = lib.mkEnableOption "openwebui";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.openwebui.enable {
    
      hardware.amdgpu.opencl.enable = true;
      hardware.graphics.extraPackages = with pkgs; [rocmPackages.clr.icd];

      systemd.tmpfiles.rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];

      services.ollama = {
        enable = true;
        acceleration = "rocm";
        rocmOverrideGfx = "10.3.0";
        port = 11434;
        host = "0.0.0.0";
        openFirewall = true;
      };
      services.open-webui = {
        enable = true;
        host = "0.0.0.0";
        port = 8080;
        openFirewall = true;

      };
      services.caddy.virtualHosts."${domain}.${tailnet}" = {
        extraConfig = ''
          reverse_proxy http://localhost:8080
          encode gzip
        '';
      };
    })
  ];
}
