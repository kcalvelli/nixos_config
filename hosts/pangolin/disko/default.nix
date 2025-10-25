# Disko configuration for fresh installation of pangolin
# 
# Usage for fresh install:
#   sudo nix run github:nix-community/disko -- --mode disko hosts/pangolin/disko/default.nix
#   sudo nixos-install --flake .#pangolin
#
# This will partition, format (with LUKS encryption), and mount the disk.

{ ... }:
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            size = "512M";
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
              name = "cryptroot";
              settings = {
                allowDiscards = true;
              };
              # LUKS passphrase will be prompted during disko run
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

  # Swapfile on encrypted root (created post-install)
  swapDevices = [{
    device = "/swapfile";
    size = 8192; # 8GB
  }];
}
