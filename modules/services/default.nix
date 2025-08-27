{pkgs, ...}: {
  # Import necessary service modules
  imports = [
    ./openwebui.nix
    ./caddy.nix
    ./ntopng.nix
    ./rclone-protondrive.nix
  ];
}
