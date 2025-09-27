{ ... }:
{
  # Import user-specific configurations
  imports = [
    ./keith.nix    
  ];

  # Configure home-manager
  home-manager = {
    useGlobalPkgs = true; # Don't create another instance of nixpkgs
    useUserPackages = true; # Install user packages directly to the user's profile
  };
}
