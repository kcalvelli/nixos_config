{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pciutils
    clinfo
    glxinfo
    xdg-user-dirs 
    desktop-file-utils
  ]; 
}