{
  pkgs,
  ...   
}:
{
  # Import common configurations
  imports = [
    ../common
    ./solaar.nix
    ./gaming.nix
  ];

  home.packages = with pkgs; [
        nextcloud-client
  ];
}
