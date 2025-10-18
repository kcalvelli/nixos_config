{ pkgs, lib, ... }:
let
  # Import categorized package lists
  packages = import ./packages.nix { inherit pkgs; };
in
{
  # === Gaming System Packages ===
  # Organized by category in packages.nix for easier management
  environment.systemPackages = packages.gaming;

  # === Gaming Programs ===
  programs = {
    # Steam configuration
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      protontricks = {
        enable = true;
        package = pkgs.protontricks;
      };

      package = pkgs.steam.override {
        extraPkgs =
          pkgs:
          (builtins.attrValues {
            inherit (pkgs.xorg)
              libXcursor
              libXi
              libXinerama
              libXScrnSaver
              ;

            inherit (pkgs.stdenv.cc.cc)
              lib
              ;

            inherit (pkgs)
              gamemode
              mangohud
              gperftools
              keyutils
              libkrb5
              libpng
              libpulseaudio
              libvorbis
              ;
          });
      };
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      gamescopeSession.enable = true;
    };

    # GameMode configuration
    gamemode = {
      enable = true;
      settings = {
        general = {
          softrealtime = "auto";
          inhibit_screensaver = 1;
          renice = 5;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          amd_performance_level = "high";
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };
}
