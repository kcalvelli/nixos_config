{ ... }:
{
  imports = [ ../../modules/disko/templates/luks-ext4.nix ];

  # Pangolin hardware configuration
  # System76 laptop with LUKS encryption
  disko.devices.disk.main = {
    device = "/dev/nvme0n1";  # Update to match actual device
  };

  # 8GB swapfile on encrypted root (matches current config)
  swapDevices = [{
    device = "/swapfile";
    size = 8000;
  }];
}
