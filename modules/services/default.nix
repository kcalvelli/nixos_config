{
  # Import necessary service modules
  imports = [
    ./openwebui.nix
    ./caddy.nix
    ./ntopng.nix
    ./home-assistant.nix
    ./mqtt.nix
  ];
}
