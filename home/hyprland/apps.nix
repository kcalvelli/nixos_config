{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Launchers and clipboard
    fuzzel
    wl-clipboard
    wtype

    # Audio and media
    playerctl
    pavucontrol
    cava

    # Screenshot and color picker
    grimblast
    grim
    slurp
    hyprpicker

    # Theming and fonts
    matugen
    colloid-gtk-theme
    colloid-icon-theme
    inter
    material-symbols
    kdePackages.qt6ct


    # Utilities
    qalculate-gtk

    # File manager
    nautilus
  ];

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

 wayland.windowManager.hyprland = {

    settings = {
      # ---- exec-once ----
      "exec-once" = [
        "solaar -w hide" 
        "nextcloud --background"  # starts minimized to the tray
      ];     
    };
  };  
}