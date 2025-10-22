# LUKS-encrypted ext4 disk layout
# - GPT partition table
# - ESP boot partition (1GB)
# - LUKS-encrypted root partition
# - Ext4 filesystem inside LUKS
# - Swapfile on encrypted root (configurable size)
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
              };
            };
            luks = {
              priority = 2;
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                };
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
    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=2G"
          "mode=1777"
        ];
      };
    };
  };

  # Configure swapfile on encrypted root
  swapDevices = [{
    device = "/swapfile";
    # Convert "8G" to integer MB: strip "G" and multiply by 1024
    size = (builtins.fromJSON (builtins.replaceStrings [ "G" "g" ] [ "" "" ] swapSize)) * 1024;
  }];
}
