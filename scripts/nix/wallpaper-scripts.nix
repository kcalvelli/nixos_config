{ config, pkgs, ... }:
{
  # Wallpaper management scripts for DankMaterialShell integration
  # Scripts handle blur generation and theme updates
  
  home.file."scripts/wallpaper-changed.sh" = {
    source = ../shell/wallpaper-blur.sh;
    executable = true;
  };

  home.file."scripts/update-material-code-theme.sh" = {
    source = ../shell/update-material-code-theme.sh;
    executable = true;
  };

  # Required dependencies for wallpaper blur functionality
  home.packages = with pkgs; [
    imagemagick     # For blur generation (provides 'magick' command)
    swaybg          # For displaying wallpaper background
  ];

  # Ensure the cache directory exists
  home.activation.createNiriCache = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p $HOME/.cache/niri
  '';
}
