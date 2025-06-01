{
  sops.secrets = {
    wireguard-privatekey = {
      format = "binary";
      sopsFile = ./wireguard-private;
      owner = "systemd-network";
    };
  };
}
