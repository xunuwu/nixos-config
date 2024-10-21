{
  sops.secrets = {
    wireguard = {
      format = "binary";
      sopsFile = ./wireguard;
    };
    wireguard-preshared = {
      key = "PresharedKey";
      sopsFile = ./wireguard.yaml;
    };
    wireguard-private = {
      key = "PrivateKey";
      sopsFile = ./wireguard.yaml;
    };
    cloudflare = {
      format = "binary";
      sopsFile = ./cloudflare;
    };
    brawlstars-api-key = {
      format = "binary";
      sopsFile = ./brawlstars;
    };
    samba = {
      format = "binary";
      sopsFile = ./samba;
    };
  };
}
