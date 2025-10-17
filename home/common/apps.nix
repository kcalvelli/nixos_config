{ pkgs, ... }:
let
  # Import categorized package lists
  packages = import ./packages.nix { inherit pkgs; };
in
{
  # === User Applications ===
  # Organized by category in packages.nix for easier management
  # Note: Browsers are installed in common/browser/
  home.packages =
    packages.notes
    ++ packages.communication
    ++ packages.documents
    ++ packages.media
    ++ packages.viewers
    ++ packages.utilities
    ++ packages.sync
    ++ packages.fonts;
}
