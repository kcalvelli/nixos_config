# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:

{
  imports =
    [
      ./disks.nix
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.home-manager.nixosModules.default
    ]
    ++ (with inputs.self.nixosModules; [
      common
      config
      desktop
      development
      fonts
      gaming
      graphics
      networking
      printing
      productivity
      sound
      msi
      users
      utils
      virtualisation
    ]);

  networking = {
    hostName = "office"; # Define your hostname.
  };
  services.resolved.extraConfig = ''
    [Resolve]
    DNS=76.76.2.22#y2p8p3h5on.dns.controld.com
    DNSOverTLS=yes
  '';
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
