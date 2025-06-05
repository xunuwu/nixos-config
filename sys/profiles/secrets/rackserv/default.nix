{
  sops.secrets = {
    wireguard-privatekey = {
      format = "binary";
      sopsFile = ./wireguard-private;
      owner = "systemd-network";
    };
    restic-password = {
      format = "binary";
      sopsFile = ./restic-password;
    };
  };
}
