# hyprland/laptop.nix
{ lib, config, ... }:

lib.mkIf (config.wayland.windowManager.hyprland.enable or false) {
  wayland.windowManager.hyprland = {
    # DMS-safe: no exec-once, no SUPER/FX keybinds, no visuals changed.
    settings = {
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
      gesture = [
        "3, horizontal, workspace"
        "3, vertical, fullscreen"
        "2, pinchout, scale: 0.5, float, float"
        "2, pinchin, scale: 0.5, float, tile"
        "3, swipe, mod: $mainMod, resize"
      ];

    };
  };
}
