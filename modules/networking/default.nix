{ lib, ... }:
{
  imports = [
    ./avahi.nix # Avahi service configuration
    ./samba.nix # Samba service configuration
    ./tailscale.nix # Tailscale service configuration
  ];

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        5355
      ];
      allowedUDPPorts = [
        5355
      ];
    };
  };

  services = {
    resolved = {
      enable = true;
      llmnr = "resolve";
      dnssec = "allow-downgrade";
      extraConfig = ''
        MulticastDNS=no
      '';
    };
    openssh.enable = true;
  };

  systemd = {
    services = {
      wpa_supplicant.serviceConfig.LogLevelMax = 2;
      NetworkManager-wait-online.enable = false;
      systemd-networkd-wait-online.enable = lib.mkForce false;
    };
  };

  programs.mtr.enable = true;

  # For RTL-SDR
  #hardware.rtl-sdr.enable = true;
}
