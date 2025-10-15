{ inputs
, self
, ...
}:
{
  # Import user-specific configurations
  imports = [
    ./keith.nix
  ];

  # Configure home-manager
  home-manager = {
    useGlobalPkgs = false; # Use separate nixpkgs instance for home-manager
    useUserPackages = true; # Install user packages directly to the user's profile
    extraSpecialArgs = {
      inherit inputs self;
    };
  };
}
