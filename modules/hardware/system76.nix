{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.hardware;
in
{
  # Import necessary modules
  imports = [
    ./common.nix
  ];

  # Define options for System76 hardware
  options = {
    hardware.system76 = {
      enable = lib.mkEnableOption "System76 hardware";
    };
  };

  # Configuration for System76 hardware
  config = lib.mkMerge [
    # System76 laptop (Pangolin 12)
    (lib.mkIf cfg.system76.enable {
      boot = {
        kernelParams = [
          "ro"
          "quiet"
          "loglevel=0"
          "splash"
          "systemd.show_status=false"
          "i8042.noaux"
        ];
        blacklistedKernelModules = [ "psmouse" ];
        initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
        ];
        kernelModules = [ "kvm-amd" ];
        extraModprobeConfig = ''
          options mt7921_common disable_clc=1
        '';
      };

      hardware = {
        system76 = {
          firmware-daemon.enable = true;
          power-daemon.enable = true;
        };
      };

      # Touchpad support
      services.xserver.synaptics.enable = false;
      services.libinput.enable = true;
    })
  ];
}
