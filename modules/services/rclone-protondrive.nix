{
  config,
  pkgs,
  lib,
  ...
}:

# Automated backup of ~/Music, ~/Documents, and ~/Pictures to Proton Drive using rclone
let
  syncDirs = [
    "${config.users.users.keith.home}/Music"
    "${config.users.users.keith.home}/Documents"
  ];
  rcloneConfig = "/home/keith/.config/rclone/rclone.conf"; # Path to rclone config file (must be set up manually)
  remote = "protondrive"; # Name of the remote as defined in rclone.conf
  serviceName = "rclone-protondrive-backup";
  syncCmds = map (dir: [
    "${pkgs.rclone}/bin/rclone"
    "sync"
    "--config"
    "${rcloneConfig}"
    dir
    "${remote}:${lib.last (lib.splitString "/" dir)}"
  ]) syncDirs;
in
{
  environment.systemPackages = with pkgs; [
    rclone
    rclone-ui
  ];

  systemd.services.${serviceName} = {
    description = "Backup user data to Proton Drive using rclone";
    serviceConfig = {
      Type = "oneshot";
      User = "keith";
      # Run each sync as an ExecStartPre, then a no-op ExecStart
      "ExecStart" = "/run/current-system/sw/bin/true";
      "ExecStartPre" = map (args: [ args ]) syncCmds;
    };
  };

  systemd.timers.${serviceName} = {
    description = "Daily backup of user data to Proton Drive at 3am";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "03:00";
      Persistent = true;
    };
  };
}
