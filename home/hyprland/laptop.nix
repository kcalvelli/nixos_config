# hyprland/laptop.nix
{ lib, ... }:

lib.mkIf (config.wayland.windowManager.hyprland.enable or false) {
  wayland.windowManager.hyprland = {
    # DMS-safe: no exec-once, no SUPER/FX keybinds, no visuals changed.
    settings = {
      # --- Touchpad settings (low priority so you can override elsewhere) ---
      input = {
        touchpad = {
          natural_scroll            = lib.mkDefault true;
          tap-to-click              = lib.mkDefault true;
          disable_while_typing      = lib.mkDefault true;
          drag_lock                 = lib.mkDefault true;
          middle_button_emulation   = lib.mkDefault true;
          # sensitivity            = lib.mkDefault 0.0;   # tweak (e.g., -0.2 .. 0.3)
          # scroll_factor          = lib.mkDefault 1.0;   # try 1.2–1.5 if desired
        };
      };

      # --- Native Hyprland gestures (works alongside your workspace binds) ---
      gestures = {
        workspace_swipe         = lib.mkDefault true;   # 3-finger swipe
        workspace_swipe_fingers = lib.mkDefault 3;
        # You can add more (distance/speed) later—kept minimal to avoid clashing
        # workspace_swipe_distance        = lib.mkDefault 350;
        # workspace_swipe_min_speed_to_force = lib.mkDefault 10.0;
        # workspace_swipe_cancel_ratio    = lib.mkDefault 0.5;
      };
    };
  };
}
