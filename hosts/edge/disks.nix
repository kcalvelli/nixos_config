{...}: {
  # Root filesystem configuration
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/de03ecfb-66a5-46dd-8626-86ed2ba75f73";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
      "data=writeback"
      "commit=60"
      "discard"
    ];
  };

  # Boot filesystem configuration
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/416A-6F8B";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # Swap device configuration
  swapDevices = [
    {device = "/dev/disk/by-uuid/d6a6574a-8d5e-492d-ad40-ca7a5718541d";}
  ];
}
