{ pkgs
, config
, ...
}:
{
  # Theming for all WMs
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    dotIcons.enable = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    theme = {
      package = pkgs.colloid-gtk-theme;
      name = "Colloid"; # or "Colloid-Dark", "Colloid-Teal-Dark", etc.
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
    style = {
      name = "Breeze";
      package = pkgs.kdePackages.breeze;
    };
  };

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "Breeze";
    XCURSOR_THEME = "Bibata-Modern-Ice";
  };

  # For Dank Colors
  xdg.configFile."gtk-4.0/gtk.css" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/gtk-4.0/dank-colors.css";
    force = true; # override anything the gtk module would write
  };

  xdg.configFile."gtk-3.0/gtk.css" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/gtk-3.0/dank-colors.css";
    force = true;
  };
}
