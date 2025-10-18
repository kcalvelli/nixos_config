{ config, pkgs, ... }:
{
  # Install wallpaper blur script to ~/scripts
  home.file."scripts/set-wallpaper-blur.sh" = {
    source = ./wallpaper-blur.sh;
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

