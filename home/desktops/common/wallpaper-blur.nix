{ ... }:
{
  # Import wallpaper management scripts
  # Moved to scripts/nix/wallpaper-scripts.nix for better organization
  imports = [
    ../../../scripts/nix/wallpaper-scripts.nix
  ];
}
