{ lib, pkgs, config, ... }:
let
  palette = {
    background = "#080C12";
    surface = "#101820";
    surfaceAlt = "#16212C";
    border = "#63D0DF";
    accent = "#63D0DF";
    accentWarm = "#FFAD63";
    accentPink = "#FF9CB1";
    text = "#DDE0E0";
    subtleText = "#93A4AA";
  };

  wallpaperSource = ../wallpapers;
  wallpaperTarget = "${config.home.homeDirectory}/Pictures/Wallpapers";

  gesturesEnabled = config.profiles.laptop.touchpadGestures.enable or false;

  rotateScript = ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    WALL_DIR="${wallpaperTarget}"
    INTERVAL="900"
    MODE="single"

    declare -a WALLPAPERS=()

    while [[ $# -gt 0 ]]; do
      case "$1" in
        --watch)
          MODE="watch"
          shift
          if [[ $# -gt 0 ]]; then
            INTERVAL="$1"
            shift
          fi
          ;;
        --interval)
          shift
          if [[ $# -gt 0 ]]; then
            INTERVAL="$1"
            shift
          fi
          ;;
        *)
          shift
          ;;
      esac
    done

    if [[ ! -d "$WALL_DIR" ]]; then
      echo "Wallpaper directory $WALL_DIR not found" >&2
      exit 1
    fi

    mapfile -d '' -t WALLPAPERS < <(find "$WALL_DIR" -type f -print0 | sort -z)

    if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
      echo "No wallpapers found in $WALL_DIR" >&2
      exit 0
    fi

    if ! command -v swww >/dev/null; then
      echo "swww is not available" >&2
      exit 0
    fi

    if ! pgrep -x swww-daemon >/dev/null; then
      swww-daemon --format xrgb >/dev/null 2>&1 &
      sleep 0.5
    fi

    last=""

    set_wallpaper() {
      local choice
      while true; do
        choice="${WALLPAPERS[$(( RANDOM % ${#WALLPAPERS[@]} ))]}"
        if [[ "$choice" != "$last" ]]; then
          last="$choice"
          break
        fi
      done

      swww img "$choice" \
        --transition-type wave \
        --transition-duration 1.2 \
        --transition-fps 60 \
        --transition-angle 30 \
        --transition-step 40
    }

    set_wallpaper

    if [[ "$MODE" == "watch" ]]; then
      while sleep "$INTERVAL"; do
        set_wallpaper
      done
    fi
  '';

  hyprColors = ''
    $blackPearlBackground = rgba(080c12ee)
    $blackPearlSurface = rgba(101820ee)
    $blackPearlAccent = rgba(63d0dfff)
    $blackPearlBorder = rgba(63d0dfdd)
    $blackPearlText = rgba(dde0e0ff)
    $blackPearlMuted = rgba(93a4aaff)
  '';

  baseHyprSettings = {
    "$mod" = "SUPER";

    env = [
      "XCURSOR_SIZE,24"
      "GTK_THEME,adw-gtk3-dark"
      "QT_QPA_PLATFORM,wayland"
      "QT_STYLE_OVERRIDE,adwaita-dark"
    ];

    source = [ "~/.config/hypr/colors.conf" ];

    monitor = [
      "eDP-1,preferred,0x0,1"
      ",preferred,auto,1"
    ];

    general = {
      gaps_in = 10;
      gaps_out = 18;
      border_size = 3;
      "col.active_border" = "$blackPearlAccent";
      "col.inactive_border" = "rgba(0a1018dd)";
      layout = "dwindle";
    };

    decoration = {
      rounding = 12;
      blur = {
        enabled = true;
        size = 8;
        passes = 3;
        noise = 0.02;
        contrast = 0.9;
        brightness = 0.85;
      };
      drop_shadow = true;
      shadow_range = 18;
      shadow_render_power = 3;
      "col.shadow" = "rgba(00000088)";
    };

    animations = {
      enabled = true;
      bezier = [
        "panel,0.05,0.9,0.1,1.1"
        "windows,0.05,0.95,0.1,1.0"
      ];
      animation = [
        "windows,1,5,windows,slide"
        "border,1,5,windows"
        "fade,1,10,default"
        "workspaces,1,6,default"
      ];
    };

    input = {
      kb_layout = "us";
      follow_mouse = 1;
      sensitivity = 0;
      accel_profile = "adaptive";
      touchpad = {
        natural_scroll = true;
        "tap-to-click" = true;
        drag_lock = true;
        scroll_factor = 0.5;
      };
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
      smart_split = true;
      force_split = 2;
    };

    misc = {
      disable_hyprland_logo = true;
      force_default_wallpaper = 0;
      background_color = "rgba(080c12ff)";
      focus_on_activate = true;
      vfr = true;
    };

    windowrulev2 = [
      "suppressevent maximize,class:.*"
      "workspace 1 silent,class:^(org.gnome.Nautilus)$"
      "workspace special silent,class:^(org.gnome.Weather)$"
    ];

    exec-once = [
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "systemctl --user start hyprland-session.target"
      "mako"
      "wl-paste --watch cliphist store"
      "quickshell"
      "${config.home.homeDirectory}/.local/bin/hyprland-rotate-wallpaper --watch 1800"
    ];

    bind = [
      "$mod,Return,exec,ghostty"
      "$mod,Space,exec,wofi --show drun"
      "$mod,E,exec,nautilus"
      "$mod,Escape,exec,wlogout"
      "$mod,Q,killactive,"
      "$mod,F,fullscreen,1"
      "$mod,V,togglefloating,"
      "$mod,left,workspace,e-1"
      "$mod,right,workspace,e+1"
      "$mod,up,workspace,m+1"
      "$mod,down,workspace,m-1"
      "$mod,1,workspace,1"
      "$mod,2,workspace,2"
      "$mod,3,workspace,3"
      "$mod,4,workspace,4"
      "$mod,5,workspace,5"
      "$mod,L,exec,hyprlock"
    ] ++ lib.optionals gesturesEnabled [
      "GESTURE:swipe:3:right,exec,hyprctl dispatch workspace e+1"
      "GESTURE:swipe:3:left,exec,hyprctl dispatch workspace e-1"
    ];

    bindm = [
      "$mod,mouse:272,movewindow"
      "$mod,mouse:273,resizewindow"
    ];

    workspace = [
      "1,monitor:eDP-1"
      "2,monitor:eDP-1"
      "3,monitor:eDP-1"
      "4,monitor:eDP-1"
      "5,monitor:eDP-1"
    ];
  };

  gestureSettings = lib.optionalAttrs gesturesEnabled {
    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 3;
      workspace_swipe_invert = false;
      workspace_swipe_cancel_ratio = 0.25;
      workspace_swipe_min_speed_to_force = 35;
    };
  };

  quickshellConfig = ''
quickshell {
  theme {
    name "Black Pearl"
    colors {
      background "${palette.background}ee"
      surface "${palette.surface}ee"
      border "${palette.border}"
      accent "${palette.accent}"
      text "${palette.text}"
      muted "${palette.subtleText}"
    }
    fonts {
      family "Inter"
      size 12
      weight 500
    }
  }

  bar "cosmic-panel" {
    monitor "all"
    layer "top"
    location "top"
    margin 8
    height 42
    padding { horizontal 14 vertical 6 }
    radius 14
    shadow { radius 24 opacity 0.2 }
    background { color "${palette.surface}ee" blur 18 }
    border { width 2 color "${palette.border}" }

    left {
      launcher {
        icon "󰀻"
        label "Applications"
        command "wofi --show drun"
        background "${palette.accent}"
        foreground "${palette.background}"
        radius 12
        padding { horizontal 12 vertical 6 }
      }
      workspaces {
        hyprland {}
        indicator {
          active { color "${palette.accent}" }
          inactive { color "${palette.surfaceAlt}" }
        }
      }
      windowtitle {
        max-length 60
        fallback "Workspace"
      }
    }

    center {
      media {
        width 320
        progress true
        accent "${palette.accentWarm}"
      }
    }

    right {
      systray { spacing 8 }
      volume {
        display "icon"
        bar-color "${palette.accent}"
      }
      network {
        format "󰤨  {ssid}"
        disconnected "󰤭"
      }
      battery {
        charging-icon "󰂄"
        discharging-icon "󰁹"
        full-icon "󰁹"
        critical-icon "󰂃"
      }
      clock {
        format "%a %d %b  %H:%M"
      }
      power {
        command "wlogout"
        icon "󰐥"
        background "${palette.accentPink}"
        foreground "${palette.background}"
      }
    }
  }

  overview {
    enable true
    accent "${palette.accent}"
    background "${palette.surfaceAlt}dd"
    workspaces { hyprland {} }
  }
}
  '';

in
{
  imports = [
  ];

  home = {
    packages = with pkgs; [
      quickshell
      swww
      wl-clipboard
      cliphist
      grim
      slurp
      swappy
      wlogout
      wofi
      brightnessctl
      playerctl
      hyprpicker
    ];

    sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      GTK_THEME = "adw-gtk3-dark";
    };

    file."Pictures/Wallpapers" = {
      source = wallpaperSource;
      recursive = true;
    };

    file.".local/bin/hyprland-rotate-wallpaper" = {
      text = rotateScript;
      executable = true;
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock >/dev/null || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 600;
            on-timeout = "pidof hyprlock >/dev/null || hyprlock";
          }
        ];
      };
    };

    mako = {
      enable = true;
      backgroundColor = "${palette.surface}cc";
      borderColor = palette.border;
      borderRadius = 12;
      defaultTimeout = 6000;
      extraConfig = ''
        text-color=${palette.text}
        progress-color=${palette.accent}
        icon-path=${config.home.homeDirectory}/.local/share/icons:${config.home.homeDirectory}/.nix-profile/share/icons
      '';
      font = "Inter 12";
    };
  };

  programs = {
    hyprlock = {
      enable = true;
      settings = {
        general = {
          background = "${palette.background}f2";
          disable_loading_bar = false;
        };
        background = [
          {
            monitor = "*";
            blur_size = 8;
            blur_passes = 3;
            noise = 0.02;
            color = "${palette.background}f2";
          }
        ];
        input-field = [
          {
            monitor = "*";
            size = "320, 52";
            outline_thickness = 2;
            dots_size = 0.4;
            dots_spacing = 0.15;
            dots_center = true;
            position = "0, -120";
            halign = "center";
            valign = "center";
            inner_color = "${palette.surface}dd";
            outer_color = "${palette.border}";
            font_color = "${palette.text}";
          }
        ];
        label = [
          {
            monitor = "*";
            text = "$TIME";
            position = "0, 80";
            halign = "center";
            valign = "center";
            color = "${palette.text}";
            font_size = 64;
          }
          {
            monitor = "*";
            text = "$DATE";
            position = "0, 140";
            halign = "center";
            valign = "center";
            color = "${palette.subtleText}";
            font_size = 20;
          }
        ];
      };
    };

    wofi = {
      enable = true;
      settings = {
        allow_images = true;
        insensitive = true;
        matching = "fuzzy";
        show = "drun";
        prompt = "Search";
      };
      theme = let
        wofiPalette = palette;
      in ''
        * {
          background-color: ${wofiPalette.background}f0;
          border-color: ${wofiPalette.border};
          color: ${wofiPalette.text};
          border-radius: 12px;
          border-width: 2px;
        }

        #input {
          margin: 12px;
          padding: 12px;
          border-radius: 12px;
          font-size: 16px;
          background-color: ${wofiPalette.surface};
        }

        #entry:selected {
          background-color: ${wofiPalette.accent};
          color: ${wofiPalette.background};
        }

        #scroll {
          margin: 12px;
          padding: 8px;
          background-color: ${wofiPalette.surfaceAlt};
          border-radius: 12px;
        }
      '';
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    settings = baseHyprSettings // gestureSettings;
  };

  xdg = {
    enable = true;
    configFile = {
      "hypr/colors.conf".text = hyprColors;
      "quickshell/config.kdl".text = quickshellConfig;
    };
  };

  programs.direnv.enable = lib.mkDefault true;
}
