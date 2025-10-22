# Standard ext4 disk layout
# - GPT partition table
# - ESP boot partition (1GB)
# - Swap partition (configurable size)
# - Ext4 root partition (remaining space)
# - Performance optimizations: noatime, nodiratime, discard

{ device ? "/dev/sda", swapSize ? "8G", ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = device;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };
            swap = {
              priority = 2;
              size = swapSize;
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              priority = 3;
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [ "noatime" "nodiratime" "discard" ];
              };
            };
          };
        };
      };
    };
  };
}
