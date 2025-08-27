in {
{ config, pkgs, lib, ... }:

# Automated backup of ~/Music, ~/Documents, and ~/Pictures to Proton Drive using rclone
let
  syncDirs = [
    "${config.users.users.keith.home}/Music"
    "${config.users.users.keith.home}/Documents"
    "${config.users.users.keith.home}/Pictures"
  ];
  rcloneConfig = "/home/keith/.config/rclone/rclone.conf"; # Path to rclone config file (must be set up manually)
  remote = "protondrive"; # Name of the remote as defined in rclone.conf
  serviceName = "rclone-protondrive-backup";
  logFile = "/var/log/rclone-protondrive-backup.log";
  syncCmd =
    let
      syncs = lib.concatMapStringsSep "\n" (dir:
        "${pkgs.rclone}/bin/rclone sync --config ${rcloneConfig} --log-file ${logFile} --log-level INFO '${dir}' '${remote}:backup/${lib.last (lib.splitString "/" dir)}'"
      ) syncDirs;
    in syncs;
in
{
  environment.systemPackages = [ pkgs.rclone ];

  systemd.services.${serviceName} = {
    description = "Backup user data to Proton Drive using rclone";
    serviceConfig = {
      Type = "oneshot";
      User = "keith";
      ExecStart = "/run/current-system/sw/bin/bash -c '${syncCmd}'";
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
