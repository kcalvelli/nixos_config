{ pkgs, inputs, ... }:
{
  wayland.windowManager.hyprland = {
    #enable = true;
    systemd.enable = true; 
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    settings = {
      cursor = {
        no_hardware_cursors = true;
      }; 

      # ---- exec-once ----
      "exec-once" = [
        "bash -c 'wl-paste --watch cliphist store' &"  # clipboard manager
        "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1"
        #"dms run"
        "solaar -w hide" 
        "nextcloud --background"  # starts minimized to the tray
      ];  

         # ---- keybinds: DMS controls ----
      bind = [
        "SUPER, Space, exec, dms ipc call spotlight toggle"
        "SUPER, V, exec, dms ipc call clipboard toggle"
        "SUPER, M, exec, dms ipc call processlist toggle"
        "SUPER, N, exec, dms ipc call notifications toggle"
        "SUPER, comma, exec, dms ipc call settings toggle"
        "SUPER, P, exec, dms ipc call notepad toggle"
        "SUPERALT, L, exec, dms ipc call lock lock"
        "SUPER, X, exec, dms ipc call powermenu toggle"
        "SUPER, C, exec, dms ipc call control-center toggle"
        "SUPER, B, exec, brave"
        "SUPER, Q, killactive"
        "SUPER, F, exec, nautilus"
        "SUPER, T, exec, ghostty"
        # Night mode toggle
        "SUPERSHIFT, N, exec, dms ipc call night toggle"
  
        # Jump directly to workspace N
        "SUPER,1,workspace,1"
        "SUPER,2,workspace,2"
        "SUPER,3,workspace,3"
        "SUPER,4,workspace,4"
        "SUPER,5,workspace,5"
        "SUPER,6,workspace,6"
        "SUPER,7,workspace,7"
        "SUPER,8,workspace,8"
        # Move between workspaces with arrows (relative)
        # Left/Up: previous, Right/Down: next
        "SUPER,LEFT,workspace,-1"
        "SUPER,UP,workspace,-1"
        "SUPER,RIGHT,workspace,+1"
        "SUPER,DOWN,workspace,+1" 
  
        # Move focused window to workspace N
        "SUPERSHIFT,1,movetoworkspace,1"
        "SUPERSHIFT,2,movetoworkspace,2"
        "SUPERSHIFT,3,movetoworkspace,3"
        "SUPERSHIFT,4,movetoworkspace,4"    
        "SUPERSHIFT,5,movetoworkspace,5"
        "SUPERSHIFT,6,movetoworkspace,6"
        "SUPERSHIFT,7,movetoworkspace,7"
        "SUPERSHIFT,8,movetoworkspace,8"  
      ];
      # ---- function-key bindings (audio/brightness) ----
      bindl = [
        ", XF86AudioRaiseVolume, exec, dms ipc call audio increment 3"
        ", XF86AudioLowerVolume, exec, dms ipc call audio decrement 3"
        ", XF86AudioMute, exec, dms ipc call audio mute"
        ", XF86AudioMicMute, exec, dms ipc call audio micmute"
        ", XF86MonBrightnessUp, exec, dms ipc call brightness increment 5 \"\""
        ", XF86MonBrightnessDown, exec, dms ipc call brightness decrement 5 \"\""
      ];
  
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];  

      # --- Touchpad settings (low priority so you can override elsewhere) ---
      input = {
        touchpad = {
          natural_scroll            = false;
          tap-to-click              = true;
          disable_while_typing      = true;
          drag_lock                 = true;
          middle_button_emulation   = true;
          # sensitivity            = lib.mkDefault 0.0;   # tweak (e.g., -0.2 .. 0.3)
          # scroll_factor          = lib.mkDefault 1.0;   # try 1.2–1.5 if desired
        };
      };

      # ---- Touchpad gestures ----
      gesture = [
        "3, horizontal, workspace"
        "3, vertical, fullscreen"
        "2, pinchout, scale: 0.5, float, float"
        "2, pinchin, scale: 0.5, float, tile"
        "3, swipe, mod: SUPER, resize"
      ];

      # ---- Monitor setup ----
      monitor = [
        # Laptop panel @ 1.00x
        "eDP-1,preferred,auto,1.00"
  
        # External 4K @ 1.5x, auto place
        "DP-2,3840x2160@60,auto,1.5"
  
        # Example ultrawide @ 1.0x (unscaled)
        # "HDMI-A-1,3440x1440@100,auto,1.0"
      ]; 

      decoration = {
        rounding = 7;
        dim_inactive = true;
        shadow = {
          enabled = true;
        };
        blur = {
          enabled = true;
        };
      }; 

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 0;
      };

      misc = {
        disable_splash_rendering = true;
      }; 

      #
      # Declare 8 workspaces (named 1..8). No monitor pinning—just the IDs.
      #
      workspace = [
        "1,name:1"
        "2,name:2"
        "3,name:3"
        "4,name:4"
        "5,name:5"
        "6,name:6"
        "7,name:7"
        "8,name:8"
      ];
    };
  };
}