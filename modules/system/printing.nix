{
  # Enable and configure printing services
  services.printing = {
    enable = true;
    openFirewall = true;
  };
  programs.system-config-printer.enable = true;
}
