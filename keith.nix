{ self, config, ... }:
let
  # User-specific configuration
  username = "keith";
  fullName = "Keith Calvelli";
  email = "keith@calvelli.dev";
  homeDir = "/home/${username}";
in
{
  # Define the user for the system
  users.users.${username} = {
    isNormalUser = true;
    description = fullName;
    initialPassword = "changeme"; # Change on first login
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

  # Home Manager configuration for the user
  home-manager.users.${username} = {
    home = {
      stateVersion = "24.05";
      homeDirectory = homeDir;
      username = username;

      # Set flake path for rebuild aliases
      sessionVariables = {
        FLAKE_PATH = "${homeDir}/.config/nixos_config";
      };
    };

    # User-specific home-manager configurations
    programs.git.settings = {
      user = {
        name = fullName;
        email = email;
      };
    };

    # User-specific Niri background path
    # This displays a blurred wallpaper in the Niri overview mode
    programs.niri.settings.spawn-at-startup = [
      {
        command = [
          "swaybg"
          "--mode"
          "stretch"
          "--image"
          "${homeDir}/.cache/niri/overview-blur.jpg"
        ];
      }
    ];
  };

  # User-specific Samba shares
  services.samba = {
    enable = true;
    settings = {
      "music" = {
        "path" = "${homeDir}/Music";
        "writable" = "yes";
        "guest ok" = "no";
      };
      "pictures" = {
        "path" = "${homeDir}/Pictures";
        "writable" = "yes";
        "guest ok" = "no";
      };
    };
  };

  # Trust this user with nix operations
  nix.settings = {
    trusted-users = [ username ];
  };
}
