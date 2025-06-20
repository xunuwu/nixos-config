{
  config,
  pkgs,
  ...
}: {
  systemd.services.slskd.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  users.users.slskd.extraGroups = ["media"];

  services.slskd = {
    enable = true;
    environmentFile = config.sops.secrets.slskd.path;
    domain = null; # why isnt this the default?
    settings = {
      metrics = {
        enabled = true;
        authentication.disabled = true;
      };
      remote_file_management = true;
      shares.directories = ["/media/library/music"];
      soulseek = {
        listen_port = 24001;
        picture = pkgs.fetchurl {
          url = "https://cdn.donmai.us/original/57/65/__kasane_teto_utau_drawn_by_nonounno__576558c9a54c63a268f9b584f1e84c9f.png";
          hash = "sha256-7WOClBi4QgOfmcMaMorK/t8FGGO7dNUwxg3AVEjRemw=";
        };
      };
      web.authentication.disabled = true;
      global = {
        upload = {
          slots = 50;
          speed_limit = 10000;
        };
        download.speed_limit = 10000;
      };
    };
  };

  environment.persistence."/persist".directories = ["/var/lib/slskd"];
}
