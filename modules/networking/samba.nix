{pkgs, ...}: {
  # Samba service configuration
  services.samba = {
    enable = true;
    package = pkgs.samba;
    nmbd.enable = false;

    # Samba settings
    settings = {
      public = {
        browseable = "yes";
        "smb encrypt" = "required";
        "wins support" = "no";
        "domain master" = "no";
        "local master" = "no";
      };
      homes = {
        browseable = "no"; # Each home will be browseable; the "homes" share will not.
        "read only" = "no";
        "guest ok" = "no";
      };
    };
  };

  # Open firewall for Samba
  services.samba.openFirewall = true;
}
