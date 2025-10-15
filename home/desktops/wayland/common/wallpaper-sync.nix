{ pkgs, ... }:
let
  # Unified script: monitors DMS wallpaper, syncs symlink, updates blur, restarts swaybg
  wallpaperBlurScript = pkgs.writeShellScript "dms-wallpaper-blur-sync" ''
    set -euo pipefail

    WALLPAPER_DIR="$HOME/Pictures/Wallpapers/New"
    SYMLINK="$WALLPAPER_DIR/current.jpg"
    CACHE="$HOME/.cache/niri"
    BLURRED="$CACHE/overview-blur.jpg"
    HASHF="$CACHE/overview-blur.sha256"
    POLL_INTERVAL=2

    mkdir -p "$WALLPAPER_DIR" "$CACHE"

    # Function to create blur and restart swaybg
    update_blur_and_swaybg() {
      if [ -r "$SYMLINK" ]; then
        local cur=$(${pkgs.coreutils}/bin/sha256sum "$(${pkgs.coreutils}/bin/readlink -f "$SYMLINK")" | ${pkgs.coreutils}/bin/cut -d" " -f1)
        local old=$([ -f "$HASHF" ] && ${pkgs.coreutils}/bin/cat "$HASHF" || echo "")
        
        if [ ! -s "$BLURRED" ] || [ "$cur" != "$old" ]; then
          ${pkgs.imagemagick}/bin/magick "$SYMLINK" -filter Gaussian -blur 0x18 "$BLURRED"
          printf '%s\n' "$cur" > "$HASHF"
          echo "$(${pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M:%S') - Blur updated for: $(${pkgs.coreutils}/bin/basename "$(${pkgs.coreutils}/bin/readlink -f "$SYMLINK")")"
          
          # Restart swaybg for overview backdrop
          ${pkgs.procps}/bin/pkill -x swaybg || true
          sleep 0.3
          ${pkgs.swaybg}/bin/swaybg --mode stretch --image "$BLURRED" >/dev/null 2>&1 &
          echo "$(${pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M:%S') - Restarted swaybg"
        fi
      fi
    }

    # Initialize blur and swaybg
    update_blur_and_swaybg

    # Monitor DMS wallpaper changes and update symlink + blur
    LAST_WP=""
    echo "DMS Wallpaper & Blur Sync started. Monitoring wallpaper changes..."

    while true; do
      CURRENT_WP=$(dms ipc call wallpaper get 2>/dev/null || echo "")
      
      if [ -n "$CURRENT_WP" ] && [ -f "$CURRENT_WP" ]; then
        if [ "$CURRENT_WP" != "$LAST_WP" ]; then
          BASENAME=$(${pkgs.coreutils}/bin/basename "$CURRENT_WP")
          CURRENT_TARGET=$(${pkgs.coreutils}/bin/readlink -f "$SYMLINK" 2>/dev/null || echo "")
          
          if [ "$CURRENT_WP" != "$CURRENT_TARGET" ]; then
            ${pkgs.coreutils}/bin/ln -sf "$BASENAME" "$SYMLINK"
            echo "$(${pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M:%S') - Symlink updated to: $BASENAME"
            
            # Update blur after symlink change
            sleep 0.5
            update_blur_and_swaybg
          fi
          
          LAST_WP="$CURRENT_WP"
        fi
      fi
      
      sleep $POLL_INTERVAL
    done
  '';
in
{
  # Systemd user service for unified wallpaper + blur management
  systemd.user.services.dms-wallpaper-blur-sync = {
    Unit = {
      Description = "DMS Wallpaper Symlink + Overview Blur Sync Service";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${wallpaperBlurScript}";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
