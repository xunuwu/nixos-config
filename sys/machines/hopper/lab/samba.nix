{config, ...}: {
  # only used for samba
  users.groups.xun = {};
  users.users.xun = {
    isSystemUser = true;
    group = "xun";
    extraGroups = ["transmission" "vault" "media"];
  };

  users.groups.vault = {};
  systemd.tmpfiles.rules = [
    "d /srv/vault 0770 root vault -"
  ];
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "log level" = 6;
        "log file" = "/var/log/samba/samba.log";
        "server string" = config.networking.hostName;
        "hosts allow" = "192.168.50.0/24";
        "map to guest" = "bad user";
      };
      transmission = {
        path = "/var/lib/transmission";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "no";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
      vault = {
        path = "/srv/vault";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0660";
        "directory mask" = "0770";
        "force user" = "xun";
        "force group" = "xun";
      };
      slskd = {
        path = "/var/lib/slskd";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0660";
        "directory mask" = "0770";
        "force user" = "slskd";
        "force group" = "slskd";
      };
      library = {
        path = "media/library";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0666";
        "directory mask" = "0777";
        "force user" = "media";
        "force group" = "media";
      };
    };
  };

  environment.persistence."/persist".directories = ["/srv/vault"];
  services.restic.backups.hopper.paths = ["/srv/vault"];
}
