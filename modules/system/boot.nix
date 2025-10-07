{
  pkgs,
  lib,
  ...
}:
{
  # Boot configuration
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.useTmpfs = true; # fewer SSD writes

    # Quiet boot
    kernelParams = [
      "quiet"
      "loglevel=0"
      "splash"
      "systemd.show_status=false"
      "psi=1"
    ];

    # Network & kernel tunables (conservative + effective)
    kernel.sysctl = {
      # BBR likes fq as default qdisc
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";

      # Reasonable buffers; let autotuning grow as needed
      "net.core.rmem_max" =  2500000;
      "net.core.wmem_max" =  2500000;
      "net.ipv4.tcp_rmem"  = "4096  87380  2500000";
      "net.ipv4.tcp_wmem"  = "4096  65536  2500000";

      # Keep, but 5000 can be loud on weak NICs—leave as-is if it helps
      "net.core.netdev_max_backlog" = 5000;

      # IPv6 enabled (0 == enabled). You can drop this since enabled is default.
      "net.ipv6.conf.all.disable_ipv6" = 0;

      # Optional: small wins
      "net.ipv4.tcp_fastopen" = 3;       # enable TFO for clients+servers
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
    memoryPercent = 25;
  };
}
