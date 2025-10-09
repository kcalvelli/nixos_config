{ lib, config, ... }:
{
  # Import common configurations
  imports = [
    ../common
    ../../wm/laptop.nix
  ];
}
