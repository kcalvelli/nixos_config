{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    cubicsdr
    gnome.gnome-calculator 
    mission-center
    wlogout
    gnome-firmware
    gnome.nautilus
    gnome.gnome-logs
    gnome.simple-scan
    snapshot  

    # Rust replacement for gnu coreutils
    uutils-coreutils-noprefix

    # Very Rusty
    atuin
    bandwhich
    bat
    bottom
    broot
    dua
    dust
    eza
    fd
    helix
    lfs
    lsd
    macchina
    ouch
    procs
    rm-improved
    ripgrep
    skim
    tokei
    xcp
    zoxide

    # Get stuff
    wget
    curl

    # Info stuff
    pciutils
    wirelesstools
    amdgpu_top
    gtop
    iw

  ];

  # Needed to enable fish completions
  programs.fish.enable = true;

  # Enable GNOME Disks
  programs.gnome-disks.enable = true;

  # Keyring support
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;  

  # Enable GNOME file stuff
  programs.file-roller.enable = true;
  services.gnome.sushi.enable = true;

environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";
environment.pathsToLink = [
  "/share/nautilus-python/extensions"
];  

}