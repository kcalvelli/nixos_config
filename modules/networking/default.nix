{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./avahi.nix # Avahi service configuration
    ./samba.nix # Samba service configuration
    ./tailscale.nix # Tailscale service configuration
  ];

  # Reduce wpa_supplicant CTRL-EVENT-SIGNAL-CHANGE spam
  systemd.services.wpa_supplicant.serviceConfig.LogLevelMax = 2;

  networking = {
    networkmanager.enable = true;
    useNetworkd = true;
    useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [5355 21118];
      # Open ports for kdeconnect protocol.  Currently using valent nightly from flatpak.
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPorts = [5355];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };

  services = {
    resolved = {
      enable = true;
    };
    openssh.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  programs.mtr.enable = true;
  programs.ssh.startAgent = true;

  # For RTL-SDR
  #hardware.rtl-sdr.enable = true;

  # Causes switch to fail if this is not set
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
}
