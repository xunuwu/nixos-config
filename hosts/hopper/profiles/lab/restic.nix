{
  config,
  pkgs,
  ...
}: {
  services.prometheus.exporters.restic = let
    resticConf = config.services.restic.backups.hopper;
  in {
    enable = true;
    inherit (resticConf) repository passwordFile environmentFile;
    refreshInterval = 3600; # 1 hour
  };

  services.restic.backups.hopper = {
    initialize = true;
    inhibitsSleep = true;
    runCheck = true;
    repository = "s3:s3.eu-central-003.backblazeb2.com/hopper-restic-backup";
    passwordFile = config.sops.secrets.restic-password.path;
    environmentFile = config.sops.secrets.restic-env.path;
    timerConfig = {
      OnCalendar = "18:00";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 6"
    ];
    paths = [
      "/media/library/music"
      "/var/lib/forgejo"
      "/var/backup/postgresql"
    ];
    exclude = [
      "/var/lib/forgejo/data/tmp"
      "/var/lib/forgejo/data/sessions"
      "/var/lib/forgejo/log"
    ];
    backupPrepareCommand = ''
      install -d -m 700 /var/backup/postgresql
      ${pkgs.util-linux}/bin/runuser -u postgres -- \
        ${config.services.postgresql.package}/bin/pg_dump forgejo \
        > /var/backup/postgresql/forgejo.sql
    '';
    backupCleanupCommand = ''
      rm -rf /var/backup/postgresql
    '';
  };
}
