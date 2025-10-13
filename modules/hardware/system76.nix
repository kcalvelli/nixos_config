{ config
, lib
, ...
}:
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
        blacklistedKernelModules = [ "psmouse" ]; # Disable PS/2 fallback touchpad
        kernelModules = [ "kvm-amd" ];
        initrd.availableKernelModules = [ "nvme" "xhci_pci" ];

        # Pangolin 12 Wi-Fi quirk (MediaTek MT7921/MT7922)
        extraModprobeConfig = ''
          options mt7921_common disable_clc=1
        '';
      };

      # Laptop power management with TLP
      services = {
        tlp = {
          enable = true;
          settings = {
            # CPU performance scaling
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
            
            # CPU boost
            CPU_BOOST_ON_AC = 1;
            CPU_BOOST_ON_BAT = 0;
            
            # CPU energy performance preference
            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
            
            # Platform profile (System76 firmware)
            PLATFORM_PROFILE_ON_AC = "performance";
            PLATFORM_PROFILE_ON_BAT = "low-power";
            
            # Disk
            DISK_DEVICES = "nvme0n1";
            DISK_APM_LEVEL_ON_AC = "254 254";
            DISK_APM_LEVEL_ON_BAT = "128 128";
            
            # SATA link power management
            SATA_LINKPWR_ON_AC = "max_performance";
            SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
            
            # WiFi power save
            WIFI_PWR_ON_AC = "off";
            WIFI_PWR_ON_BAT = "on";
            
            # Runtime PM for PCI(e) devices
            RUNTIME_PM_ON_AC = "auto";
            RUNTIME_PM_ON_BAT = "auto";
            
            # USB autosuspend
            USB_AUTOSUSPEND = 1;
            USB_EXCLUDE_BTUSB = 1; # Don't autosuspend Bluetooth
          };
        };
        
        # SSD TRIM
        fstrim.enable = true;
        
        # Disable power-profiles-daemon (conflicts with TLP)
        power-profiles-daemon.enable = lib.mkForce false;
      };
    })
  ];
}
