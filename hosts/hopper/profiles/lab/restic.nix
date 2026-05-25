{config, ...}: {
  services.prometheus.exporters.restic = let
    resticConf = config.services.restic.backups.hopper;
  in {
    enable = true;
    inherit (resticConf) repository passwordFile;
    refreshInterval = 3600; # 1 hour
  };

  services.restic.backups.hopper = {
    initialize = true;
    inhibitsSleep = true;
    repository = "rest:http://nixdesk:8000/hopper";
    passwordFile = config.sops.secrets.restic-password.path;
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
    ];
  };
}
