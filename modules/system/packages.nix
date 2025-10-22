{ pkgs }:
{
  # Core system utilities
  core = with pkgs; [
    killall
    wget
    curl
  ];

  # Filesystem and mount tools
  filesystem = with pkgs; [
    sshfs
    fuse
    ntfs3g
  ];

  # System monitoring and information
  monitoring = with pkgs; [
    pciutils
    wirelesstools
    gtop
    htop
    lm_sensors
    smartmontools
  ];

  # Archive and compression tools
  archives = with pkgs; [
    p7zip
    unzip
    unrar
    xarchiver
  ];

  # Security and secret management
  security = with pkgs; [
    libsecret
    lssecret
    openssl
  ];

  # Nix ecosystem tools
  nix = with pkgs; [
    fh # Flake helper CLI
  ];
}
