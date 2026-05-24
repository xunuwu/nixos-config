{
  sops.secrets = let
    loadYamlKey = key: sopsFile: overrides:
      {
        inherit sopsFile key;
        format = "yaml";
      }
      // overrides;
  in {
    wireguard-privatekey = {
      format = "binary";
      sopsFile = ./wireguard-private;
      owner = "systemd-network";
    };
    restic-password = {
      format = "binary";
      sopsFile = ./restic-password;
    };
    cloudflare = {
      format = "binary";
      sopsFile = ./cloudflare;
    };
  };
}
