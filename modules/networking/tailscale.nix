{ config, ... }:
{
  # Configure firewall settings for Tailscale
  networking = {
    firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ]; # Allow Tailscale interface through the firewall
      allowedUDPPorts = [ config.services.tailscale.port ]; # Allow UDP ports used by Tailscale
    };
  };

  # Enable and configure Tailscale service
  services = {
    tailscale = {
      enable = true; # Enable Tailscale service
      openFirewall = true;
      useRoutingFeatures = "both"; # Enable both inbound and outbound routing features
      permitCertUid = config.services.caddy.user; # Permit certificate UID for the Caddy user
    };
  };
}
