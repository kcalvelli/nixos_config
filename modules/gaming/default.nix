{
  pkgs,
  config,
  inputs,
  ...
}: {
  programs = {
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
        env = {
          WLR_RENDERER = "vulkan";
          WINE_FULLSCREEN_FSR = "1";
        };
        args = [
          "--output-width"
          "1920"
          "--output-height"
          "1080"
          "--adaptive-sync"
          "--steam"
        ]; 
      };
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}