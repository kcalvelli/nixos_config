# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../system/apps

      # Define users
      ../../users/keith

      inputs.self.nixosModules.desktop
      inputs.self.nixosModules.plasma
      inputs.self.nixosModules.msi
      inputs.self.nixosModules.virtualization
      inputs.self.nixosModules.apps
      inputs.kde2nix.nixosModules.default       

    ];

  networking = { 
    hostName = "office"; # Define your hostname.
  };
}
