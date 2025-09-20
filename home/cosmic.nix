{ 
  config, 
  pkgs, 
  lib, 
  ... 
}:
let
  # xdg-utils, but with xdg-open wrapped to handle kdeconnect:// directly
  xdgUtilsWithKdeconnectOpen = pkgs.runCommand "xdg-utils-with-kdeconnect-open" {} ''
    mkdir -p $out/bin
    for f in ${pkgs.xdg-utils}/bin/*; do
      base="$(basename "$f")"
      if [ "$base" = "xdg-open" ]; then
        cat > "$out/bin/xdg-open" <<'SH'
#!${pkgs.bash}/bin/bash
case "$1" in
  kdeconnect://*)
    exec ${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-handler "$1"
    ;;
  *)
    exec ${pkgs.xdg-utils}/bin/xdg-open "$@"
    ;;
esac
SH
        chmod +x "$out/bin/xdg-open"
      else
        ln -s "$f" "$out/bin/$base"
      fi
    done
  '';
in
{
  #### 1) KDE Connect (daemon + tray)
  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  #### 2) Ensure XDG is on and the scheme handler is registered
  xdg.enable = true;

  # Desktop entry for the kdeconnect:// URL scheme
  xdg.desktopEntries.kdeconnect-url-handler = {
    name = "KDE Connect URL Handler";
    exec = "${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-handler %u";
    terminal = false;
    type = "Application";
    noDisplay = true;
    mimeType = [ "x-scheme-handler/kdeconnect" ];
    categories = [ "Utility" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/kdeconnect" = [ "kdeconnect-url-handler.desktop" ];
    };
    associations.added = {
      "x-scheme-handler/kdeconnect" = [ "kdeconnect-url-handler.desktop" ];
    };
  };

  #### 3) Packages on PATH — note we use the wrapped xdg-utils (no duplicates)
  home.packages = [
    xdgUtilsWithKdeconnectOpen
    pkgs.desktop-file-utils
    pkgs.kdePackages.kdeconnect-kde
  ];

  # Optional: some apps look at $BROWSER; harmless to keep
  home.sessionVariables.BROWSER = lib.mkDefault "xdg-open";
}