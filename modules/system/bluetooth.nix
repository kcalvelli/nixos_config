{
  config,
  lib,
  pkgs,
  ...
}:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.dbus.enable = true;
}