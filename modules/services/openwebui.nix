{ config, lib, pkgs, ... }:
let
  cfg = config.services;
  domain = config.networking.hostName;
  tailnet = "taile0fb4.ts.net";
in
{
  options = {
    services.openwebui = {
      enable = lib.mkEnableOption "openwebui";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.openwebui.enable {

      hardware.amdgpu.opencl.enable = true;
      hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];

      systemd.tmpfiles.rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];

      services = {
        ollama = {
          enable = true;
          acceleration = "rocm";
          rocmOverrideGfx = "10.3.0";
          port = 11434;
          host = "0.0.0.0";
          openFirewall = true;
        };
        open-webui = {
          enable = true;
          host = "0.0.0.0";
          port = 8080;
          openFirewall = true;
          environment = {
            STATIC_DIR = "${config.services.open-webui.stateDir}/static";
            DATA_DIR = "${config.services.open-webui.stateDir}/data";
            HF_HOME = "${config.services.open-webui.stateDir}/hf_home";
            SENTENCE_TRANSFORMERS_HOME = "${config.services.open-webui.stateDir}/transformers_home";
          };
        };
        caddy = {
          virtualHosts = {
            "${domain}.${tailnet}" = {
              extraConfig = ''
                  handle_path /ai/* {
                reverse_proxy http://127.0.0.1:8080
                  }
              '';
            };
          };
        };
      };
    })
  ];
}
