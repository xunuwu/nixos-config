{config, ...}: {
  services.restic.backups.rackserv = {
    initialize = true;
    inhibitsSleep = true;
    repository = "rest:http://nixdesk:8000/rackserv";
    passwordFile = config.sops.secrets.restic-password.path;
    timerConfig = {
      OnCalendar = "18:00";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 3"
    ];
  };
}
