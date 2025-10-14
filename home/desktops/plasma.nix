{ pkgs
, ...
}:
{
  programs.brave.nativeMessagingHosts = with pkgs; [ kdePackages.plasma-browser-integration ];

  # home.packages = with pkgs; [
  #   xdg-utils
  #   kdePackages.kio             # KIO core
  #   kdePackages.kio-extras      # smb, fish, ftp, etc. (use kio-extras6 on Plasma 6)
  # ];

  # xdg.mimeApps = {
  #   enable = true;
  #   defaultApplications = {
  #     "x-scheme-handler/http"  = [ "brave-browser.desktop" ];  # or your browser
  #     "x-scheme-handler/https" = [ "brave-browser.desktop" ];
  #     "text/html"              = [ "brave-browser.desktop" ];
  #     "inode/directory"        = [ "org.kde.dolphin.desktop" ];
  #   };
  # };    
}
