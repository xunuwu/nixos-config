{
  sops.secrets = {
    wireguard = {
      format = "binary";
      sopsFile = ./wireguard;
    };
  };
}
