## TODO use defaultSopsFile mayb
{config, ...}: {
  sops.secrets = {
    wireguard = {
      format = "binary";
      sopsFile = ./wireguard;
    };
    slskd = {
      format = "binary";
      sopsFile = ./slskd;
    };
    cloudflare = {
      format = "binary";
      sopsFile = ./cloudflare;
    };
    transmission = {
      format = "binary";
      sopsFile = ./transmission;
    };
    navidrome = {
      format = "binary";
      sopsFile = ./navidrome;
    };
    restic-password = {
      format = "binary";
      sopsFile = ./restic-password;
    };
    vaultwarden-env = {
      format = "binary";
      sopsFile = ./vaultwarden-env;
    };
  };
}
