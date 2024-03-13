{
  sops.secrets = {
    wireguard = {
      format = "binary";
      sopsFile = ./wireguard;
    };
    #wireguard-preshared = {
    #  format = "yaml";
    #  sopsFile = ./wireguard.yaml;
    #};
    wireguard-private = {
      format = "yaml";
      sopsFile = ./wireguard.yaml;
      key = "PrivateKey";
    };
  };
}
