{ pkgs, inputs, ... }:
{
  imports = [
    ./common/apps.nix
    ./common/theming.nix
    ./common/material-code-theme.nix
    ./common/wallpaper-blur.nix
    ./niri.nix
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
  ];

  programs.dankMaterialShell = {
    enable = true;
    quickshell.package = inputs.quickshell.packages.${pkgs.system}.default;
    #enableSystemd = true;  
  };

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };
}

