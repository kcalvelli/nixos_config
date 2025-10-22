{ config, lib, ... }:
{
  hardware = {
    # Update AMD CPU microcode if redistributable firmware is enabled
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableAllFirmware = true;
  };
}
