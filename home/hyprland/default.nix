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
  ];

  programs.dankMaterialShell = {
    enable = true;
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
    };
  };
}
