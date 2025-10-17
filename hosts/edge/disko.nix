{ ... }:
{
  imports = [ ../../modules/disko/templates/standard-ext4.nix ];

  # Edge hardware configuration
  # Desktop workstation with NVMe drive
  disko.devices.disk.main = {
    device = "/dev/nvme0n1";  # Update to match actual device
    content.partitions.swap.size = "16G";  # 16GB swap for desktop
  };
}
