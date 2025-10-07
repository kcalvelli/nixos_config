{
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
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
  };
}