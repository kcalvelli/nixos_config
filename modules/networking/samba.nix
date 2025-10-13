{ ...
}:
{
  services.samba = {
    enable = true;
    openFirewall = true;

    # Disable legacy NetBIOS browser; prefer WS-Discovery instead.
    nmbd.enable = false;

    settings = {
      # --- Global settings ---
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "%h Samba";
        "map to guest" = "Bad User";

        # Security posture
        "smb encrypt" = "required"; # or "desired" if you need broader client support
        "server min protocol" = "SMB2_02";
        "client min protocol" = "SMB2_02";
        "ntlm auth" = "no"; # disable NTLMv1

        # We’re not doing classic browsing / WINS
        "wins support" = "no";
        "local master" = "no";
        "domain master" = "no";
        "preferred master" = "no";
        "dns proxy" = "no";

        # Printer stack off (speeds up startup if you don’t share printers)
        "load printers" = "no";
        "disable spoolss" = "yes";
        "printing" = "bsd";
        "printcap name" = "/dev/null";
      };

      # --- Example public share ---
      public = {
        path = "/srv/samba/public"; # <-- REQUIRED
        "read only" = "no";
        "guest ok" = "no"; # set "yes" if you want guest access
        browseable = "yes";
        # "valid users" = "@smbshare";  # optional: restrict to a group
      };

      # --- Homes share (special Samba share) ---
      homes = {
        browseable = "no";
        "read only" = "no";
        "guest ok" = "no";
      };
    };
  };

  # Modern Windows discovery without NetBIOS:
  services.samba-wsdd.enable = true;

  # Optional: create the public share directory and group
  users.groups.smbshare = { };
  systemd.tmpfiles.rules = [
    "d /srv/samba/public 0770 root smbshare - -"
  ];
}
