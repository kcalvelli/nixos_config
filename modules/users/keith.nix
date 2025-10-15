{ ...
}:
{
  # Define the user for the system
  users.users = {
    keith = {
      isNormalUser = true;
      description = "Keith Calvelli";
      extraGroups = [
        "networkmanager"
        "wheel"
        "kvm"
        "input"
        "disk"
        "libvirtd"
        "plugdev"
        "qemu-libvirtd"
        "video"
        "adm"
        "lp"
        "scanner"
      ];
    };
  };

  # Home Manager configuration for the user
  home-manager.users = {
    keith = {
      home = {
        stateVersion = "24.05";
        homeDirectory = "/home/keith";
        username = "keith";
      };
      #Home Manager’s own nixpkgs (Option B: independent from system)
      nixpkgs = {
        config = {
          allowUnfree = true;
          allowBroken = false;
          allowUnsupportedSystem = false;
        };
      };

    };
  };

  # User specific samba configuration
  services.samba = {
    enable = true;
    settings = {
      "music" = {
        "path" = "/home/keith/Music";
        "writable" = "yes";
        "guest ok" = "no";
      };
      "pictures" = {
        "path" = "/home/keith/Pictures";
        "writable" = "yes";
        "guest ok" = "no";
      };
    };
  };

  # Learn to trust yourself
  nix.settings = {
    trusted-users = [ "keith" ];
  };
}
