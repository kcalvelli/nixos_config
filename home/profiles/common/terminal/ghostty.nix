{ config, pkgs, lib, inputs, ... }:

let
  hyprlandEnabled = config.wayland.windowManager.hyprland.enable or false;
  homeDir = config.home.homeDirectory;
in
{
  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.system}.default;
    enableFishIntegration = true;
    installVimSyntax = true;

    # Only emit inline settings when Hyprland is NOT enabled
    settings = lib.mkIf (!hyprlandEnabled) {
      background = "#080c12";
      foreground = "#e0e4e9";
      cursor-color = "#2a3a4e";
      selection-background = "#2a3a4e";
      selection-foreground = "#e0e4e9";
      font-family = "FiraCode Nerd Font Mono";
      font-size = 12;
      palette = [
        "0=#080c12"
        "1=#e06c75"
        "2=#98c379"
        "3=#e5c07b"
        "4=#61afef"
        "5=#c678dd"
        "6=#56b6c2"
        "7=#e0e4e9"
        "8=#9ca4ae"
        "9=#ff7b86"
        "10=#a3d48a"
        "11=#f0d08c"
        "12=#72c0ff"
        "13=#d789ff"
        "14=#67c7d3"
        "15=#ffffff"
      ];
    };
  };

  # Make sure we do NOT also write the config when Hyprland is enabled.
  # (Preempt any other definition the Ghostty module might set.)
  xdg.configFile."ghostty/config".enable = lib.mkIf hyprlandEnabled false;

  # After HM writes files, force ~/.config/ghostty/config -> config-dankcolors.
  home.activation.ghosttySymlink =
    lib.mkIf hyprlandEnabled (lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -e
      target="${homeDir}/.config/ghostty/config-dankcolors"
      link="${homeDir}/.config/ghostty/config"

      # Create parent dir just in case
      mkdir -p "${homeDir}/.config/ghostty"

      # Replace whatever HM (or anything else) left there with our symlink
      if [ -e "$link" ] || [ -L "$link" ]; then
        rm -f "$link"
      fi
      ln -s "$target" "$link"

      if [ ! -f "$target" ]; then
        echo "[home-manager] WARNING: $target is missing; Ghostty config will be a dangling symlink."
      fi
    '');
}
