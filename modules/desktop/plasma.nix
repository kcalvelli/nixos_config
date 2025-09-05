{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
{
  # Define Cosmic options
  options.plasma = {
    enable = lib.mkEnableOption "Enable Plasma desktop environment";
  };

  # Configure Plasma if enabled
  config = lib.mkIf config.plasma.enable {

    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
      flatpak.enable = true;
    };

    programs = {
      # Force KDE's ssh-askpass over Seahorse's
      ssh.askPassword = lib.mkForce "${pkgs.plasma5Packages.ksshaskpass}/bin/ksshaskpass";
      kdeconnect.enable = true;
      partition-manager.enable = true;
    };

    environment.systemPackages = with pkgs; [
      kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
      kdePackages.kcalc # Calculator
      kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
      kdePackages.kcolorchooser # A small utility to select a color
      kdePackages.kolourpaint # Easy-to-use paint program
      kdePackages.ksystemlog # KDE SystemLog Application
      kdePackages.sddm-kcm # Configuration module for SDDM
      kdiff3 # Compares and merges 2 or 3 files or directories
      kdePackages.isoimagewriter # Optional: Program to write hybrid ISO files onto USB disks
      hardinfo2 # System information and benchmarks for Linux systems
      haruna # Open source video player built with Qt/QML and libmpv
      wayland-utils # Wayland utilities
      wl-clipboard # Command-line copy/paste utilities for Wayland
      kdePackages.kdenlive # Video editor
      digikam # Photo management
      krita # Digital painting application
      kdePackages.calligra # Office suite
    ];

    # Enable some homeManager stuff
    home-manager.sharedModules = with inputs.self.homeModules; [
      plasma
    ];
  };
}
