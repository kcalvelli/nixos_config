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
    #./overview.nix
    ./theming.nix
    ./apps.nix
    ./material-code-theme.nix
  ];

  programs.dankMaterialShell = {
    enable = true;
    quickshell.package = inputs.quickshell.packages.${pkgs.system}.default;
    # enableSystemd = true;
  };
  
  wayland.windowManager.hyprland = {
    enable = true;
    # optional, but nice: run Hyprland as user service + enable XWayland
    systemd.enable = true;
    xwayland.enable = true; 
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    settings = {
      # ---- exec-once ----
      "exec-once" = [
        "bash -c 'wl-paste --watch cliphist store &'"
        "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1"
        "dms run"
      ];  
      cursor = {
        no_hardware_cursors = true;
      };         
    };
  };
}
