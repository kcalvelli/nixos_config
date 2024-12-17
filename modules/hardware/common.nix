{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./boot.nix
    ./printing.nix
    ./sound.nix
  ];

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableAllFirmware = true;
  };

  powerManagement.cpuFreqGovernor = "schedutil";
  # Firmware
  services.fwupd.enable = true;
}
