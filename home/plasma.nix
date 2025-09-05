{
  pkgs,
  ...
}:
{
  programs.brave.nativeMessagingHosts = with pkgs; [ kdePackages.plasma-browser-integration ];
}
