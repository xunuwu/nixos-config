## TODO use defaultSopsFile mayb
{config, ...}: let
  # autheliaUser = config.services.authelia.instances.main.user;
in {
  sops.secrets = {
    wireguard = {
      format = "binary";
      sopsFile = ./wireguard;
    };
    grafana-pass = {
      format = "binary";
      sopsFile = ./grafana-pass;
    };
    wireguard-config = {
      format = "binary";
      sopsFile = ./wireguard-config;
    };

    slskd = {
      format = "binary";
      sopsFile = ./slskd;
      # restartUnits = ["podman-slskd.service"];
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

    transmission = {
      format = "binary";
      sopsFile = ./transmission;
    };

    authentik = {
      format = "binary";
      sopsFile = ./authentik;
    };

    "kanidm/admin_pass" = {
      sopsFile = ./kanidm.yaml;
      owner = "kanidm";
    };
    "kanidm/idm_admin_pass" = {
      sopsFile = ./kanidm.yaml;
      owner = "kanidm";
    };

    # "keycloak/db" = {
    #   sopsFile = ./keycloak.yaml;
    #   owner = "keycloak";
    # };
    #
    "lldap/jwt" = {
      sopsFile = ./lldap.yaml;
      owner = "lldap";
    };

    "lldap/password" = {
      sopsFile = ./lldap.yaml;
      owner = "lldap";
    };

    # authelia
    authelia_lldap_password = {
      format = "yaml";
      sopsFile = ./authelia.yaml;
      key = "lldap_password";
      # owner = autheliaUser;
    };
    authelia_jwt_secret = {
      format = "yaml";
      sopsFile = ./authelia.yaml;
      key = "jwt_secret";
      # owner = autheliaUser;
    };
    authelia_session_secret = {
      format = "yaml";
      sopsFile = ./authelia.yaml;
      key = "session_secret";
      #owner = autheliaUser;
    };
    authelia_encryption_key = {
      format = "yaml";
      sopsFile = ./authelia.yaml;
      key = "encryption_key";
      #owner = autheliaUser;
    };
    authelia_storage_password = {
      format = "yaml";
      sopsFile = ./authelia.yaml;
      key = "storage_password";
      #owner = autheliaUser;
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
