{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Browsers
    #brave is installed in commmon/browser

    # Note-taking Apps
    obsidian

    # Social Apps
    discord

    # Markdown Editors
    typora

    # File Send/Sync Tools
    localsend

    # Video Editing
    pitivi

    # Graphics and video Apps
    pinta
    shotwell
    loupe
    inkscape
    celluloid

    # Disk Utilities
    baobab

    # Music
    amberol

    # Fonts
    nerd-fonts.fira-code

    # Nextcloud desktop Client
    nextcloud-client    

    swappy

    libreoffice-fresh
  ];
}