{ pkgs, inputs, ... }:
{
  imports = [
    ./common/apps.nix
    ./common/theming.nix
    ./common/material-code-theme.nix
    ./hyprland.nix
    #./niri.nix
  ];

  programs.dankMaterialShell = {
    enable = true;
    quickshell.package = inputs.quickshell.packages.${pkgs.system}.default;
    # enableSystemd = true;
  };  
}

