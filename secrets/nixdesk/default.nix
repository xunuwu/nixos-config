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
