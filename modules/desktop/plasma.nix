{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  # Define Cosmic options
  options.plasma = {
    enable = lib.mkEnableOption "Enable Plasma desktop environment";
  };

  # Configure Plasma if enabled
  config = lib.mkIf config.cosmic.enable {

    services.xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    services.xrdp = {
      defaultWindowManager = "startplasma-x11";
      enable = true;
      openFirewall = true;
    };

    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.enable = true;
    services.displaymanager.sddm.wayland.enable = true;
    services.flatpak.enable = true;    

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
      kdePackages.partitionmanager # Optional Manage the disk devices, partitions and file systems on your computer
      hardinfo2 # System information and benchmarks for Linux systems
      haruna # Open source video player built with Qt/QML and libmpv
      wayland-utils # Wayland utilities
      wl-clipboard # Command-line copy/paste utilities for Wayland
    ];

    # Enable some homeManager stuff
    home-manager.sharedModules = with inputs.self.homeModules; [
      tui
    ];
  };
}