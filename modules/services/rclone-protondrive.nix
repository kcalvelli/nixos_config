{ config
, pkgs
, lib
, ...
}:

let
  cfg = config.services.rclone-protondrive;
  types = lib.types;
  serviceName = "rclone-protondrive-backup";
in
{
  options.services.rclone-protondrive = {
    enable = lib.mkEnableOption "Automated Proton Drive backups via rclone";

    user = lib.mkOption {
      type = types.str;
      default = "keith";
      description = "POSIX user that owns the data and runs the backup job.";
    };

    directories = lib.mkOption {
      type = types.listOf types.str;
      default = [
        "Music"
        "Documents"
      ];
      example = [
        "/srv/shared"
        "Pictures"
      ];
      description = ''
        Directories to sync to Proton Drive. Relative paths are resolved against the
        target user's home directory.
      '';
    };

    remote = lib.mkOption {
      type = types.str;
      default = "protondrive";
      description = "Name of the rclone remote to sync to.";
    };

    configFile = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Absolute path to the rclone configuration file. Defaults to
        ~/.config/rclone/rclone.conf for the target user when unset.
      '';
    };

    workingDirectory = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Working directory for the backup unit. Defaults to the target user's home
        directory when unset.
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    let
      userHome =
        let
          home = lib.attrByPath [ cfg.user "home" ] config.users.users null;
        in
        if home != null then home else "/home/${cfg.user}";
      workingDir =
        if cfg.workingDirectory != null then cfg.workingDirectory else userHome;
      rcloneConfigFile =
        if cfg.configFile != null then cfg.configFile else "${userHome}/.config/rclone/rclone.conf";
      toAbsolute = dir:
        if lib.hasPrefix "/" dir then dir else "${userHome}/${dir}";
      resolvedDirs = map toAbsolute cfg.directories;
      remotePathFor = dir:
        let
          components = lib.filter (part: part != "") (lib.splitString "/" dir);
          base = if components != [ ] then lib.last components else cfg.user;
        in
        "${cfg.remote}:${base}";
      syncCommands = map
        (dir: lib.escapeShellArgs [
          "rclone"
          "sync"
          "--config"
          rcloneConfigFile
          dir
          (remotePathFor dir)
        ])
        resolvedDirs;
    in
    {
      environment.systemPackages = with pkgs; [
        rclone
        rclone-ui
      ];

      systemd.services.${serviceName} = {
        description = "Backup user data to Proton Drive using rclone";
        path = [ pkgs.rclone ];
        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
          WorkingDirectory = workingDir;
          # Run each sync as an ExecStartPre, then a no-op ExecStart
          ExecStart = "/run/current-system/sw/bin/true";
          ExecStartPre = syncCommands;
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
  );
}
