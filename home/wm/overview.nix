{
  pkgs, 
  inputs,
  ...
}: 
{
  wayland.windowManager.hyprland = {
    plugins = [
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
    ];    

    settings = {
      bind = [
        # Hyprexpo toggle
        #"SUPER, GRAVE, hyprexpo:expo, toggle"

        # Hyprspace overview toggle - currently broken
        "SUPER, Tab, overview:toggle, all"
      ];

      plugin = {
        # hyprexpo = {
        #   rows = 3;
        #   columns = 3;
        #   gap_size = 240;
        #   bg_col = "rgb(f5bde6)";
        #   workspace_method = "center current";
        #   enable_gesture = true;
        #   gesture_fingers = 3;
        #   gesture_distance = 300;
        #   gesture_positive = true;
        # };
      };
    };
  };
}