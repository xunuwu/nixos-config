{
  sops.secrets = {
    wireguard = {
      format = "binary";
      sopsFile = ./wireguard;
    };
    wg-private = {
      key = "PrivateKey";
      sopsFile = ./wireguard.yaml;
      group = "systemd-network";
      mode = "0640";
    };
    wg-preshared = {
      key = "PresharedKey";
      sopsFile = ./wireguard.yaml;
      group = "systemd-network";
      mode = "0640";
    };

    serverenv = {
      format = "binary";
      sopsFile = ./serverenv;
    };
    code-server = {
      format = "binary";
      sopsFile = ./code-server;
    };
    slskd = {
      format = "binary";
      sopsFile = ./slskd;
      restartUnits = ["podman-slskd.service"];
    };
    cloudflare = {
      format = "binary";
      sopsFile = ./cloudflare;
    };
    jackett = {
      format = "binary";
      sopsFile = ./jackett;
      restartUnits = ["podman-qbittorrent.service"];
    };
    betanin = {
      format = "binary";
      sopsFile = ./betanin;
      restartUnits = ["podman-betanin.service"];
    };

    # authelia
    authelia_jwt_secret = {
      format = "yaml";
      sopsFile = ./authelia.yaml;
      key = "jwt_secret";
    };
    authelia_session_secret = {
      format = "yaml";
      sopsFile = ./authelia.yaml;
      key = "session_secret";
    };
    authelia_encryption_key = {
      format = "yaml";
      sopsFile = ./authelia.yaml;
      key = "encryption_key";
    };
    authelia_storage_password = {
      format = "yaml";
      sopsFile = ./authelia.yaml;
      key = "storage_password";
    };
    brawlstars-api-key = {
      format = "binary";
      sopsFile = ./brawlstars;
    };
    wakapi = {
      format = "binary";
      sopsFile = ./wakapi;
      mode = "004";
    };
  };
}
