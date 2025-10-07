{ 
  pkgs,
  lib, 
  config,
  ... 
}:
{
  wayland.windowManager.hyprland = {
    settings = {
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
    };
  };
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };  

  gtk = {
    enable = true;

    theme = {
      package = pkgs.colloid-gtk-theme;
      name    = "Colloid";   # or "Colloid-Dark", "Colloid-Teal-Dark", etc.
    };
  };

  # For Dank Colors
  xdg.configFile."gtk-4.0/gtk.css" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/gtk-4.0/dank-colors.css";
    force = true;   # override anything the gtk module would write
  };

  xdg.configFile."gtk-3.0/gtk.css" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/gtk-3.0/dank-colors.css";
    force = true;
  };    
}
