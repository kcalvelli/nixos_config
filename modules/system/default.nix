{
  pkgs,
  ...
}:
{
  # Import necessary modules
  imports = [
    ./local.nix
    ./nix.nix
    ./boot.nix
    ./printing.nix
    ./sound.nix
    ./bluetooth.nix
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    # Common apps
    sshfs
    fuse
    ntfs3g

    # Utilities
    killall

    # Network tools
    wget
    curl

    # System info tools
    pciutils
    wirelesstools
    gtop
    htop

    # Secret management/encryption
    libsecret
    lssecret
    openssl

    # Archive tools
    p7zip
    unzip
    unrar
    xarchiver

    # Flakehub CLI
    fh

    lm_sensors
    smartmontools
 
  ];

  # Build smaller systems
  documentation.enable = false;
  documentation.nixos.enable = false;
  documentation.dev.enable = false;
  programs.command-not-found.enable = false;



}
