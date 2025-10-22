{ pkgs, ... }:
let
  # Import categorized package lists
  packages = import ../packages.nix { inherit pkgs; };
in
{
  # === Wayland Desktop Applications ===
  # Organized by category in packages.nix for easier management
  home.packages =
    packages.launchers
    ++ packages.audio
    ++ packages.screenshot
    ++ packages.themes
    ++ packages.fonts
    ++ packages.qt
    ++ packages.utilities;

  # === Wayland Services ===
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
