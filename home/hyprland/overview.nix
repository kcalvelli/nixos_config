{
  pkgs, 
  inputs,
  ...
}: 
{
  wayland.windowManager.hyprland = {
    plugins = [
      # If you vendored the Hyprspace flake input:
      inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];

    settings = {
      bind = [
        # Hyprexpo toggle
        "SUPER, TAB, hyprexpo:expo, toggle"

        # Hyprspace overview toggle - currently broken
        #"SUPER, TAB, exec, hyprctl dispatch overview:toggle"
      ];

      plugin = {
        hyprexpo = {
          rows = 3;
          columns = 3;
          gap_size = 240;
          bg_col = "rgb(f5bde6)";
          workspace_method = "center current";
          enable_gesture = true;
          gesture_fingers = 3;
          gesture_distance = 300;
          gesture_positive = true;
        };
      };
    };
  };
}