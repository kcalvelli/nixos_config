{
  inputs,
  pkgs,
  ...
}:
{
  # Import necessary modules
  imports = [
    ./disks.nix
  ]
  ++ (with inputs.self.nixosModules; [
    system
    desktop
    development
    services
    graphics
    msi
    networking
    users
    virt
    gaming
  ]);

  # Enable MSI hardware support
  hardware.msi.enable = true;

  # Enable virtualization
  virt = {
    libvirt.enable = true;
    containers.enable = true;
  };

  # Since we dual boot with Windows, we need to set the clock to localtime
  time.hardwareClockInLocalTime = true;

  # Enable services
  services = {
    caddy-proxy.enable = true;
    # openwebui.enable = true;
    # ntop.enable = true;
    hass.enable = true;
  };

  # Use workstation configuration for Home Manager
  home-manager.sharedModules = with inputs.self.homeModules; [ workstation ];

  # Define Hostname
  networking = {
    hostName = "edge";
  };
}
