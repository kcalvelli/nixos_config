{ pkgs }:
{
  # Launchers and input
  launchers = with pkgs; [
    fuzzel
    wl-clipboard
    wtype
  ];

  # Audio control
  audio = with pkgs; [
    playerctl
    pavucontrol
    cava
  ];

  # Screenshot and screen tools
  screenshot = with pkgs; [
    grimblast
    grim
    slurp
    hyprpicker
  ];

  # Theming and appearance
  themes = with pkgs; [
    matugen
    colloid-gtk-theme
    colloid-icon-theme
    adwaita-icon-theme
    papirus-icon-theme
  ];

  # Fonts for Wayland UI
  fonts = with pkgs; [
    inter
    material-symbols
  ];

  # Qt configuration
  qt = with pkgs; [
    kdePackages.qt6ct
  ];

  # Utilities
  utilities = with pkgs; [
    qalculate-gtk
    swaybg
    imagemagick
    libnotify
    gnome-software
    gnome-text-editor
  ];
}
