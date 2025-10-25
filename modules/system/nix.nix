{ lib, self, ... }:
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
      substitute = true;
      builders-use-substitutes = true;
      download-buffer-size = 256 * 1024 * 1024;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      
      # Build performance optimizations
      cores = 0; # Use all available cores
      max-jobs = "auto"; # Parallel builds
      
      extra-substituters = [
        "https://numtide.cachix.org"
        "https://niri.cachix.org"
      ];
      extra-trusted-substituters = [
        "https://niri.cachix.org"
      ];

      extra-trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431kS1gBOk6429S9g0f1NXtv+FIsf8Xma0="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
      trusted-users = [ "root" "@wheel" ];
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