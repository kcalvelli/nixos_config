{...}: {
  imports = [
    ./security.nix # Security settings
    ./browser.nix # Brave browser configuration
    ./terminal.nix # Common terminal settings
  ];
}
