{...}: {
  # Root filesystem configuration
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0b2ada2d-7811-470a-b8f8-33bc70fd05f6";
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
    device = "/dev/disk/by-uuid/965A-9731";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # Swap device configuration
  swapDevices = [
    {device = "/dev/disk/by-uuid/6e052123-d4a9-42c9-8a49-4f97e80800b8";}
  ];
}
