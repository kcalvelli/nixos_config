{
  config,
  pkgs,
  ...
}: {
  # Import common configurations
  imports = [
    ./common.nix
  ];
}
