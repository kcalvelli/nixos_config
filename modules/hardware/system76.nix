{ config, lib, pkgs, ... }:
let
  cfg = config.hardware;
in
{
  imports = [ ./common.nix ];

  options.hardware.system76.enable =
    lib.mkEnableOption "Enable System76 (Pangolin 12) hardware integration";

  config = lib.mkMerge [
    (lib.mkIf cfg.system76.enable {
      # --- System76 hardware integration ---
      hardware.system76 = {
        firmware-daemon.enable = true;
        power-daemon.enable = true;
      };

      # --- Kernel parameters & modules ---
      boot = {
        blacklistedKernelModules = [ "psmouse" ];  # Disable PS/2 fallback touchpad
        kernelModules = [ "kvm-amd" ];
        initrd.availableKernelModules = [ "nvme" "xhci_pci" ];

        # Pangolin 12 Wi-Fi quirk (MediaTek MT7921/MT7922)
        extraModprobeConfig = ''
          options mt7921_common disable_clc=1
        '';
      };

      # --- Power & thermal management ---
      powerManagement = {
        enable = true;
        cpuFreqGovernor = lib.mkDefault "schedutil"; 
      };

      # --- Input devices ---
      services.xserver = {
        synaptics.enable = false;
        libinput.enable = true;
      };
    })
  ];
}
