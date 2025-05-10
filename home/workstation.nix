{
  config,
  pkgs,
  ...
}: {
  # Import common configurations
  imports = [
    ./common.nix
    ./solaar.nix
    ./gaming.nix
  ];
}
