# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/230433ef-e237-477a-9d99-3bcd60ff5cfd";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-48c3f721-7627-4254-8a96-c077659ab2dd".device = "/dev/disk/by-uuid/48c3f721-7627-4254-8a96-c077659ab2dd";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0FCA-458D";
      fsType = "vfat";
    };

  fileSystems."/home/keith/Pictures" =
    { device = "/dev/disk/by-uuid/0806889f-a4b5-4f10-99e9-777cffb4c807";
      fsType = "ext4";
    };

  fileSystems."/mnt/data" =
    { device = "/dev/disk/by-uuid/ed69a535-afc7-45d5-be77-dc1b06282f06";
      fsType = "ext4";
    };

  fileSystems."/home/keith/Games" =
    { device = "/dev/disk/by-uuid/d0fe2c38-85eb-4dff-84ca-411de9171e80";
      fsType = "ext4";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp39s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp41s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}