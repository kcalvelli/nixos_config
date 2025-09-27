{
  lib,
  ...
}:
{
  # Nix configuration
  nix = {
    # Enable daily automatic garbage collection, delete generations older than 5 days
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 5d";
    };

    # Nix settings
    settings = {
      download-buffer-size = 256 * 1024 * 1024;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      substituters = [
        "https://cosmic.cachix.org/"
      ];
      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      ];
      trusted-users = [ "root" ];
    };
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  # Set system state version
  system.stateVersion = "24.05"; # Ensure compatibility with NixOS 24.05
}
