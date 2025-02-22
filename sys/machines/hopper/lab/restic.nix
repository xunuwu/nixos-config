{config, ...}: {
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
      "--keep-monthly 12"
      "--keep-yearly 2"
    ];
    paths = [
      "/media/library/music"
    ];
  };
}
