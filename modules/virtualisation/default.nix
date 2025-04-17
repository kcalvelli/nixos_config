{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.virt;
in {
  # Create options to enable containers and virtualisation
  options = {
    virt.containers = {
      enable = lib.mkEnableOption "Enable containers";
    };
    virt.libvirt = {
      enable = lib.mkEnableOption "Enable libvirt";
    };
  };

  # Enable and configure containers with podman
  config = lib.mkMerge [
    (lib.mkIf cfg.containers.enable {
      virtualisation = {
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings = {
            dns_enabled = true;
          };
        };
      };
      # Uncomment if you want to use waydroid
      #virtualisation.waydroid.enable = true;
    })

    (lib.mkIf cfg.libvirt.enable {
      # Keep virtualization simple with quickemu
      environment.systemPackages = with pkgs; [
        #inputs.quickemu.packages.x86_64-linux.default
        quickemu
        quickgui
      ];

      # Allow redirection of USB devices
      virtualisation = {
        spiceUSBRedirection.enable = true;
      };
      services.spice-vdagentd.enable = true;
    })
  ];
}
