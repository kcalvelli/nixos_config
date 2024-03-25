{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    htop
    pciutils
    clinfo
    usbutils
    aha
    wl-clipboard
    zip
    unzip
  ];
}    