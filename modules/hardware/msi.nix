{ config, lib, pkgs, ... }:
let
  cfg = config.hardware;
in
{
  imports = [ ./common.nix ];

  options.hardware.msi.enable = lib.mkEnableOption "MSI motherboard tweaks";

  config = lib.mkMerge [
    (lib.mkIf cfg.msi.enable {
      hardware = {
        # Logitech Unifying receiver support
        logitech.wireless.enable = true;
        logitech.wireless.enableGraphical = true;
      };

      # Kernel modules/params for this MSI board
      boot = {
        kernelModules = [
          "kvm-amd"
          "nct6775"  # Super I/O sensors (fans/temps) for many MSI boards incl. MS-7C37
        ];

        kernelParams = [
          "acpi_enforce_resources=lax" # required to expose nct6775 on many MSI boards
        ];

        initrd.availableKernelModules = [
          "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"
        ];
      };

      # Desktop-friendly power policy (fine on Ryzen)
      powerManagement = {
        enable = true;
        cpuFreqGovernor = lib.mkDefault "schedutil";
      };

      # Useful, real services
      services = {
        fstrim.enable = true;   # weekly TRIM
        irqbalance.enable = true;
        power-profiles-daemon.enable = lib.mkForce false; # not useful on desktops
      };
    })
  ];
}
