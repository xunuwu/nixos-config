{
  config,
  pkgs,
  ...
}: {
  systemd.services.slskd.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

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
        listen_port = 26449;
        picture = pkgs.fetchurl {
          url = "https://cdn.donmai.us/original/57/65/__kasane_teto_utau_drawn_by_nonounno__576558c9a54c63a268f9b584f1e84c9f.png";
          hash = "sha256-7WOClBi4QgOfmcMaMorK/t8FGGO7dNUwxg3AVEjRemw=";
        };
      };
      global = {
        upload = {
          slots = 50;
          speed_limit = 10000;
        };
        download.speed_limit = 10000;
      };
    };
  };
}
