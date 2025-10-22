{ pkgs }:
{
  # Note-taking and knowledge management
  notes = with pkgs; [
    obsidian
  ];

  # Communication and social
  communication = with pkgs; [
    discord
  ];

  # Document editors and viewers
  documents = with pkgs; [
    typora # Markdown editor
    libreoffice-fresh
  ];

  # Media creation and editing
  media = with pkgs; [
    pitivi # Video editor
    pinta # Image editor
    inkscape # Vector graphics
  ];

  # Media viewing and playback
  viewers = with pkgs; [
    shotwell # Photo manager
    loupe # Image viewer
    celluloid # Video player
    amberol # Music player
  ];

  # System utilities
  utilities = with pkgs; [
    baobab # Disk usage analyzer
    swappy # Screenshot annotation
  ];

  # Cloud and sync
  sync = with pkgs; [
    nextcloud-client
  ];

  # Fonts
  fonts = with pkgs; [
    nerd-fonts.fira-code
  ];
}
