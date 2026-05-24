{
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
    samba = {
      format = "binary";
      sopsFile = ./samba;
    };
  };
}
