## TODO use defaultSopsFile mayb
{config, ...}: {
  sops.secrets = let
    loadYamlKey = key: sopsFile: overrides:
      {
        inherit sopsFile key;
        format = "yaml";
      }
      // overrides;
  in {
    wireguard = {
      format = "binary";
      sopsFile = ./wireguard;
    };
    discord-webhook = {
      format = "binary";
      owner = "alertmanager";
      group = "alertmanager";
      sopsFile = ./discord-webhook;
      restartUnits = ["alertmanager.service"];
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
    miniflux = {
      format = "binary";
      sopsFile = ./miniflux;
    };
    roblox-playtime = {
      format = "binary";
      sopsFile = ./roblox-playtime;
      owner = "roblox-playtime";
      group = "roblox-playtime";
    };
    samba-pass = {
      format = "binary";
      sopsFile = ./samba-pass;
      mode = "0600";
    };
    nebula-cert = loadYamlKey "nebula-cert" ./nebula.yaml {
      group = "nebula-xunmesh";
      mode = "0644";
    };
    nebula-key = loadYamlKey "nebula-key" ./nebula.yaml {
      group = "nebula-xunmesh";
      mode = "0644";
    };
    nebula-ca-cert = loadYamlKey "nebula-ca-cert" ./nebula.yaml {
      group = "nebula-xunmesh";
      mode = "0644";
    };
  };
}
