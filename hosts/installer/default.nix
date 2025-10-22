{ ... }:
{
  # Import installer configuration
  # Moved to scripts/nix/installer.nix for better organization
  imports = [
    ../../scripts/nix/installer.nix
  ];
}
