{ inputs, ... }:
{
  # Import user-specific configurations
  imports = [
    ./keith.nix
    # Import Home Manager's NixOS module here once for the entire tree
    inputs.home-manager.nixosModules.default
  ];

  # Configure home-manager
  home-manager = {
    extraSpecialArgs.inputs = inputs; # Forward the inputs
    useGlobalPkgs = true; # Don't create another instance of nixpkgs
    useUserPackages = true; # Install user packages directly to the user's profile
  };
}
