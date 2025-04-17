{pkgs, ...}: {
  # Enable and configure printing services
  services.printing = {
    enable = true;
    openFirewall = true;
    drivers = [
      pkgs.hplipWithPlugin
      pkgs.hplip
    ];
  };
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.hplipWithPlugin];
  };

  # MDNS has been unreliable for reaching the printer
  networking.hosts = {
    "192.168.68.51" = ["HPDeskJet2750e.local" "HPDeskJet2750e"];
  };

  programs.system-config-printer.enable = true;
}
