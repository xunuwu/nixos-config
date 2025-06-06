{
  sops.secrets = {
    wireguard = {
      format = "binary";
      sopsFile = ./wireguard;
    };
    samba = {
      format = "binary";
      sopsFile = ./samba;
    };
  };
}
