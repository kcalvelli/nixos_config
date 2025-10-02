{ lib, ... }:
{
  imports = [
    ../common
  ];

  options.profiles.laptop.touchpadGestures.enable = lib.mkEnableOption ''
    Enable Hyprland touchpad gestures tuned for three-finger workspace navigation.
  '';

  config = {
    profiles.laptop.touchpadGestures.enable = lib.mkDefault true;
  };
}
