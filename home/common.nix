{...}: {
  imports = [
    ./shell.nix # Shell configuration
    ./security.nix # Security settings
    ./browser.nix # Brave browser configuration
  ];
}
