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
    };
    cloudflare = {
      format = "binary";
      sopsFile = ./cloudflare;
    };
  };
}
