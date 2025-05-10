{
  inputs,
  pkgs,
  ...
}: {
  # Import necessary modules
  imports =
    [
      ./disks.nix
      inputs.home-manager.nixosModules.default
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
  virt.libvirt.enable = true;
  virt.containers.enable = true;

  # Since we dual boot with Windows, we need to set the clock to localtime
  time.hardwareClockInLocalTime = true;

  # Enable services
  services.caddy-proxy.enable = true;
  services.openwebui.enable = true;
  services.ntop.enable = false;

  # Use workstation configuration for Home Manager
  home-manager.sharedModules = with inputs.self.homeModules; [workstation];

  # Define Hostname
  networking = {
    hostName = "edge";
  };
}
