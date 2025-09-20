{ 
  config, 
  pkgs, 
  lib, 
  ... 
}:
{
  # KDE Connect (daemon + tray)
  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  xdg.enable = true;

  home.packages = [
    pkgs.xdg-utils
    pkgs.desktop-file-utils
    pkgs.kdePackages.kdeconnect-kde
  ];
}