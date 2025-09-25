{ ... }:
{
  imports = [
    ./security.nix # Security settings
    ./browser # Brave browser configuration
    ./terminal.nix # Common terminal settings
  ];
}
