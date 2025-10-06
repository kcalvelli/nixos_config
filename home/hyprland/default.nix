{ 
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./monitors.nix
    ./keybindings.nix
    ./workspaces.nix
    ./overview.nix
  ];

  programs.dankMaterialShell.enable = true;
  
  wayland.windowManager.hyprland = {
    enable = true;
    # optional, but nice: run Hyprland as user service + enable XWayland
    systemd.enable = true;
    xwayland.enable = true; 
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    settings = {
      # ---- exec-once ----
      "exec-once" = [
        # Clipboard history (cliphist) watcher
        ''bash -c "wl-paste --watch cliphist store &"''
        # Polkit agent (NixOS path; replace with another agent if you prefer)
        "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1"
        # Start DankMaterialShell
        "dms run"
      ]; 
      decoration = {
          rounding = 7;
      }; 
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 0;
      };
    };
  };
    
  home.packages = with pkgs; [
      fuzzel
      playerctl
      pavucontrol
      brightnessctl
      grimblast
      hyprpicker
      wayvnc
      wl-clipboard
      wtype
      matugen
      cava
      colloid-gtk-theme
      colloid-icon-theme

  ];
}
