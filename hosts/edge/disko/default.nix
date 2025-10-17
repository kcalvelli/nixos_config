# Disko configuration for fresh installation of edge
# 
# Usage for fresh install:
#   sudo nix run github:nix-community/disko -- --mode disko hosts/edge/disko/default.nix
#   sudo nixos-install --flake .#edge
#
# This will partition, format, and mount the disk according to the spec below.

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
            size = "16G";
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
}
