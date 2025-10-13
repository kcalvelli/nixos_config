{ config
, pkgs
, lib
, inputs
, hyprlandEnabled ? false
, ...
}:
{
  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.system}.default;
    enableFishIntegration = true;
    installVimSyntax = true;
  };

  xdg.configFile."ghostty/config".enable = false;

  # After HM writes files, force ~/.config/ghostty/config -> config-dankcolors.
  home.activation.ghosttySymlink =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -e
      target="${config.home.homeDirectory}/.config/ghostty/config-dankcolors"
      link="${config.home.homeDirectory}/.config/ghostty/config"

      mkdir -p "${config.home.homeDirectory}/.config/ghostty"

      if [ -e "$link" ] || [ -L "$link" ]; then
        rm -f "$link"
      fi
      ln -s "$target" "$link"

      if [ ! -f "$target" ]; then
        echo "[home-manager] WARNING: $target is missing; Ghostty config will be a dangling symlink."
      fi
    '';
}
