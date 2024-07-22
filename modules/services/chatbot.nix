{ config, lib, pkgs, ... }:
let 
  cfg = config.services;
in 
{
  options = {
    services.chatbot = {
      enable = lib.mkEnableOption "chatbot";
    };
  };

  config = lib.mkMerge [
      (lib.mkIf cfg.chatbot.enable {
        services.ollama = {
          enable = true;
          acceleration = "rocm";
          environmentVariables = {
            HCC_AMDGPU_TARGET = "gfx1031";
          };
          rocmOverrideGfx = "10.3.1";
          port = 11434;
          host = "127.0.0.1";
        };
        services.open-webui = {
          enable = true;
          host = "127.0.0.1";
          port = 8080;
          openFirewall = false;
          environment = {
            ANONYMIZED_TELEMETRY = "False";
            DO_NOT_TRACK = "True";
            SCARF_NO_ANALYTICS = "True";
            OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
            # Disable authentication
            WEBUI_AUTH = "False";
            ENABLE_SIGNUP = "False";
            WEBUI_URL = "http://localhost:8080";      
          };
        };  
      })
  ];    
}