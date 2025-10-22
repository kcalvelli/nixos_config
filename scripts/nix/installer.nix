{ pkgs, modulesPath, lib, ... }:
{
  # axiOS Installer ISO Configuration
  # This module configures the installation media
  
  imports = [
    # Use minimal installer as base
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    
    # For graphical installer, use this instead:
    # "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
  ];

  # ISO Configuration
  image.baseName = lib.mkForce "axios-installer-${pkgs.stdenv.hostPlatform.system}";
  
  isoImage = {
    volumeID = lib.mkForce "AXIOS_INSTALL";
    
    # Compression for smaller ISO
    squashfsCompression = "zstd -Xcompression-level 15";
    
    # Optional: Add custom splash screen
    # splashImage = ../../docs/logo.png;
    
    # Make the installer more user-friendly
    makeEfiBootable = true;
    makeUsbBootable = true;
  };

  # Hostname for installer environment
  networking.hostName = "axios-installer";

  # Enable NetworkManager for easy WiFi setup
  networking.networkmanager.enable = lib.mkForce true;
  networking.wireless.enable = lib.mkForce false; # Disable wpa_supplicant in favor of NetworkManager

  # Essential installation tools
  environment.systemPackages = with pkgs; [
    # Version control
    git
    
    # Editors
    vim
    neovim
    nano
    
    # Network utilities
    wget
    curl
    networkmanagerapplet
    
    # Disk management tools
    gparted
    parted
    testdisk
    ddrescue
    
    # System information
    lshw
    pciutils
    usbutils
    lsof
    htop
    btop
    
    # Filesystem tools
    ntfs3g
    exfat
    dosfstools
    
    # Utilities
    tmux
    screen
    ripgrep
    fd
    fzf
    tree
    
    # Debugging
    gdb
    strace
  ];

  # Include the installer script in the ISO
  environment.etc."axios-installer.sh" = {
    source = ../shell/install-axios.sh;
    mode = "0755";
  };

  # Create convenient symlink
  system.activationScripts.installer-link = ''
    ln -sf /etc/axios-installer.sh /root/install
  '';

  # Auto-clone configuration repository on boot
  systemd.services.clone-axios = {
    description = "Clone axiOS configuration repository";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
    };
    
    script = ''
      if [ ! -d /root/nixos_config ]; then
        cd /root
        ${pkgs.git}/bin/git clone --depth 1 https://github.com/kcalvelli/nixos_config
        
        # Make installer script executable
        chmod +x /root/nixos_config/scripts/shell/install-axios.sh
        
        # Create welcome message
        cat > /root/WELCOME.txt <<'EOF'
╔════════════════════════════════════════╗
║   Welcome to axiOS Installer!         ║
╚════════════════════════════════════════╝

⚠️  SECURE BOOT NOTICE ⚠️
This installer cannot boot with Secure Boot enabled.
If you had to disable Secure Boot to boot this ISO,
you can re-enable it after installation completes.
The installed system includes Lanzaboote for Secure Boot support.

To install axiOS, run:
  /root/install

Or manually:
  cd /root/nixos_config
  ./scripts/shell/install-axios.sh

For WiFi setup:
  nmtui

Documentation & Source:
  https://github.com/kcalvelli/nixos_config

EOF
        
        # Display welcome message
        cat /root/WELCOME.txt
      fi
    '';
  };

  # Show welcome message on login
  programs.bash.loginShellInit = ''
    if [ -f /root/WELCOME.txt ]; then
      cat /root/WELCOME.txt
    fi
  '';

  # Enable helpful shell features
  programs.bash.interactiveShellInit = ''
    # Convenient aliases
    alias ll='ls -lah'
    alias install='/root/install'
    alias axios-install='/etc/axios-installer.sh'
    
    # Show helpful info
    echo ""
    echo "Type 'install' to begin axiOS installation"
    echo "Type 'nmtui' to configure WiFi"
    echo ""
  '';

  # Allow passwordless sudo for installer environment
  security.sudo.wheelNeedsPassword = lib.mkForce false;

  # Enable flakes and nix-command for installer
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Increase inotify limits for development tools
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };

  # Auto-login to speed up installer experience
  services.getty.autologinUser = lib.mkForce "root";

  # Use latest kernel for better hardware support
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Disable ZFS (often broken with latest kernel)
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
}
