{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  environment = {
    pathsToLink = [ "/share/pixmaps" ];
    systemPackages = with pkgs; [
      qt6ct
      #qadwaitadecorations-qt6
      inputs.self.packages.${pkgs.system}.adwaitadecorations-black
    ];
    variables = {
      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_WAYLAND_DECORATION = "adwaita";
    };
  };
}
