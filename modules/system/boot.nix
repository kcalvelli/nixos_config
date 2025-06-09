{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # Boot configuration
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    kernel.sysctl = {
      # Network Optimizations
      "net.core.rmem_max" = 1048576; # Sets the maximum receive socket buffer size to 1MB
      "net.core.wmem_max" = 1048576; # Sets the maximum send socket buffer size to 1MB
      "net.ipv4.tcp_window_scaling" = 1; # Enables TCP window scaling
      "net.ipv4.ttcp_rmem" = "4096 87380 1048576"; # Sets the minimum, default, and maximum TCP receive buffer sizes
      "net.ipv4.tcp_wmem" = "4096 65536 1048576"; # Sets the minimum, default, and maximum TCP send buffer sizes
      "net.core.netdev_max_backlog" = 5000; # Sets the maximum number of packets allowed to queue when the interface receives packets faster than the kernel can process them
      "net.ipv4.tcp_congestion_control" = "bbr"; # Uses BBR congestion control algorithm to reduce latency and increase throughput
      "net.ipv6.conf.all.disable_ipv6" = 0; # Enables IPv6 for accessing IPv6-only networks or future-proofing
    };

    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    # Enable SecureBoot
    lanzaboote = {
      enable = true;
      configurationLimit = 5;
      pkiBundle = "/var/lib/sbctl";
    };

    bootspec.enable = true;

    # Enable systemd but keep it quiet
    initrd = {
      systemd.enable = true;
      verbose = false;
    };

    # Quiet, pretty startup
    plymouth.enable = true;
    consoleLogLevel = 0;
  };

  # Swap configuration
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 30;
  };

  # Enable UDisks2 service
  services.udisks2.enable = true;
}
