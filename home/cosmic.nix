{ 
  config, 
  pkgs, 
  lib, 
  ... 
}:
{
  # KDE Connect for COSMIC (works on any non-KDE desktop)
  services.kdeconnect = {
    enable = true;              # runs kdeconnectd in your session
    indicator = true;           # starts the tray UI (indicator-kdeconnect)
    package = pkgs.kdePackages.kdeconnect-kde;  # explicit, stable choice
  };

  # Optional: CLI tools handy for scripting (pairing, file send, etc.)
  # Not strictly required because the service pulls the package above,
  # but keeping it here exposes the binaries on PATH explicitly.
  home.packages = [
    pkgs.kdePackages.kdeconnect-kde
  ];

  # No COSMIC-specific tweaks needed; the indicator shows in COSMIC’s tray.
}
