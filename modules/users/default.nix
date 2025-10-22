{ inputs, self, lib, ... }:
let
  # Auto-discover all user files in this directory
  # Any .nix file that isn't default.nix or README.md will be imported
  userFiles = builtins.filter
    (name: name != "default.nix" && lib.hasSuffix ".nix" name)
    (builtins.attrNames (builtins.readDir ./.));
  
  # Convert filenames to imports
  userImports = map (file: ./. + "/${file}") userFiles;
in
{
  # Auto-import all user configurations
  imports = userImports;

  # Configure home-manager
  home-manager = {
    useGlobalPkgs = false; # Use separate nixpkgs instance for home-manager
    useUserPackages = true; # Install user packages directly to the user's profile
    extraSpecialArgs = {
      inherit inputs self;
    };
  };
}
