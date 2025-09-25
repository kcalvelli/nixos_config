{ 
  config, 
  pkgs, 
  lib, 
  inputs,
  ... 
}:
{
  imports = [
    inputs.cosmic-manager.homeManagerModules.cosmic-manager
  ];

  # KDE Connect (daemon + tray)
  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = pkgs.valent;
  };

  xdg.enable = true;

  home.packages = [
    pkgs.xdg-utils
    pkgs.desktop-file-utils
    #pkgs.kdePackages.kdeconnect-kde
  ];
}