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
  };
}
