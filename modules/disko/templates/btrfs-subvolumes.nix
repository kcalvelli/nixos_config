# Btrfs disk layout with subvolumes
# - GPT partition table
# - ESP boot partition (1GB)
# - Btrfs root with subvolumes
# - Subvolumes: @root, @home, @nix, @snapshots
# - Built-in compression (zstd)
# - Swap partition (configurable size)
# - Optimizations: noatime, space_cache=v2, discard=async

{ device ? "/dev/sda", swapSize ? "8G", compression ? "zstd", ... }:
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
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=${compression}" "noatime" "space_cache=v2" "discard=async" ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=${compression}" "noatime" "space_cache=v2" "discard=async" ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=${compression}" "noatime" "space_cache=v2" "discard=async" ];
                  };
                  "@snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [ "compress=${compression}" "noatime" "space_cache=v2" "discard=async" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
