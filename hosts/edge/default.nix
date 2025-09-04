{
  inputs,
  pkgs,
  config,
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

  # Enable services - caddy proxy isn't working great (my setup fault, I haven't messed with it much) so only enable one at a time.
  services.caddy-proxy.enable = true;
  #services.openwebui.enable = true;
  #services.ntop.enable = true;
  services.hass = {
    enable = true;
  };

  # Use workstation configuration for Home Manager
  home-manager.sharedModules = with inputs.self.homeModules; [workstation];

  # Hate to put this here, but I only want nextcloud on one machine now since I am also using syncthing
  environment.systemPackages = with pkgs; [
    nextcloud-client
  ];

  # Define Hostname
  networking = {
    hostName = "edge";
  };
}
