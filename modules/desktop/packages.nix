{ pkgs }:
{
  # VPN applications
  vpn = with pkgs; [
    protonvpn-gui
    protonvpn-cli
  ];

  # Streaming and recording
  streaming = [
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-gstreamer
        obs-move-transition
        obs-backgroundremoval
      ];
    })
  ];
}
