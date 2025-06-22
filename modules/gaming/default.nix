{ 
  pkgs, 
  config, 
  inputs, 
  lib, 
  ... 
}:
let
  WIDTH = 3840;
  HEIGHT = 2160;
  REFRESH_RATE = 60;
  VRR = true;
  HDR = false;

  gamescope-env = ''
    set -x CAP_SYS_NICE eip
    set -x DXVK_HDR 1
    set -x ENABLE_GAMESCOPE_WSI 1
    set -x ENABLE_HDR_WSI 1
    set -x AMD_VULKAN_ICD RADV
    set -x RADV_PERFTEST aco
    set -x SDL_VIDEODRIVER wayland
    set -x STEAM_FORCE_DESKTOPUI_SCALING 1
    set -x STEAM_GAMEPADUI 1
    set -x STEAM_GAMESCOPE_CLIENT 1
  '';

  gamescope-base-opts =
    [
      "--fade-out-duration" "200"
      "-w" "${toString WIDTH}"
      "-h" "${toString HEIGHT}"
      "-r" "${toString REFRESH_RATE}"
      "-f"
      "--expose-wayland"
      "--backend" "sdl"
      "--rt"
      "--immediate-flips"
    ]
    ++ lib.optional HDR "--hdr-enabled"
    ++ lib.optional HDR "--hdr-debug-force-output"
    ++ lib.optional HDR "--hdr-itm-enable"
    ++ lib.optional VRR "--adaptive-sync";

  gamescope-run = pkgs.writeScriptBin "gamescope-run" ''
    #!/usr/bin/env fish

    ${gamescope-env}

    argparse -i 'x/extra-args=' -- $argv
    if test $status -ne 0
      exit 1
    end

    if test (count $argv) -eq 0
      echo "Usage: gamescope-run [-x|--extra-args \"<options>\"] <command> [args...]"
      echo ""
      echo "Examples:"
      echo "  gamescope-run -x \"--fsr-upscaling-sharpness 5\" steam"
      echo "  GAMESCOPE_EXTRA_OPTS=\"--fsr\" gamescope-run steam (legacy)"
      exit 1
    end

    set -l final_args ${lib.escapeShellArgs gamescope-base-opts}

    if set -q _flag_extra_args
      set -a final_args (string split ' ' -- $_flag_extra_args)
    end

    if set -q GAMESCOPE_EXTRA_OPTS
      set -a final_args (string split ' ' -- $GAMESCOPE_EXTRA_OPTS)
    end

    exec ${lib.getExe pkgs.gamescope} $final_args -- $argv
  '';

  steam-wrapper = pkgs.writeScriptBin "steam" ''
    #!/usr/bin/env fish
    exec ${gamescope-run}/bin/gamescope-run -x "-e" ${lib.getExe pkgs.steam} -tenfoot -steamdeck -gamepadui $argv
  '';

  steamBigPictureCmd = "${steam-wrapper}/bin/steam";

in {
  environment.systemPackages = with pkgs; [
    gamescope
  ];

  programs = {
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

    gamemode = {
      enable = true;
      settings = {
        general = {
          softrealtime = "auto";
          inhibit_screensaver = 1;
          renice = 15;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1;
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
