{
  # Traditional filesystem declarations for existing LUKS-encrypted system
  # Disko is best used for fresh installs; for existing systems,
  # traditional NixOS filesystem declarations work better
  
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1d49e97d-0c15-4463-84ad-58cf59fbd68b";
    fsType = "ext4";
    options = [ "noatime" "nodiratime" "discard" ];
  };

  boot.initrd.luks.devices."luks-3c8ff0c7-6af4-49b6-813e-64111b334775".device =
    "/dev/disk/by-uuid/3c8ff0c7-6af4-49b6-813e-64111b334775";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A2DB-DC72";
    fsType = "vfat";
  };

  swapDevices = [{
    device = "/swapfile";
  }];
}
