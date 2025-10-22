{ ...
}:
{
  imports = [
    ./security.nix # Security settings
    ./browser # Brave browser configuration
    ./terminal # Common terminal settings and programs
    ./apps.nix # Common applications
    ./calendar.nix # Khal + vdirsyncer configuration
  ];
}
