## TODO look into sops-nix placeholders
## reference: https://github.com/javigomezo/nixos/blob/b3ebe8d570ea9b37aea8bb3a343f6e16e054e322/services/network/authelia/user_database.nix
{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  l = lib // builtins;
  domain = "xunuwu.xyz";
  caddyPort = 8336;
  slskdUiPort = 23488;
  caddyLocal = 8562;
  ncPort = 46523;
  kanidmPort = 8300;
in {
  ## TODO use kanidm
  ## TODO use impermanence
  ## TODO setup fail2ban mayb

  users.groups.media = {};
  users.users.media = {
    isSystemUser = true;
    group = "media";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "xunuwu@gmail.com";
    certs = {
      ${domain} = {
        domain = "*.${domain}";
        dnsProvider = "cloudflare";
        reloadServices = ["caddy.service"];
        credentialFiles.CF_DNS_API_TOKEN_FILE = config.sops.secrets.cloudflare.path;
        extraDomainNames = [domain];
      };
      "kanidm.${domain}" = {
        domain = "kanidm.${domain}";
        group = "kanidm";
        dnsProvider = "cloudflare";
        reloadServices = ["caddy.service" "kanidm.service"];
        credentialFiles.CF_DNS_API_TOKEN_FILE = config.sops.secrets.cloudflare.path;
      };
    };
  };

  ## make sure vpn connection is reasonably fast
  ## god, there has to be a proper, not horrible way of doing this
  # systemd.services."wg-speedcheck" = {
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecCondition = "${config.systemd.package}/bin/systemctl is-active wg.service"; # horrible, horrible hack, theres 100% a better way
  #     ExecStart = pkgs.writers.writeBash "wg-speedcheck.sh" ''
  #       echo "running test in netns"
  #       vpn_result=$( ${pkgs.iproute2}/bin/ip netns exec wg ${pkgs.speedtest-cli}/bin/speedtest --json )
  #       vpn_download=$( echo "$vpn_result" | ${l.getExe pkgs.jq} '.download' )
  #       vpn_upload=$( echo "$vpn_result" | ${l.getExe pkgs.jq} '.upload' )
  #
  #       echo "running test outside of netns"
  #       normal_result=$( ${pkgs.speedtest-cli}/bin/speedtest --json )
  #       normal_download=$( echo "$normal_result" | ${l.getExe pkgs.jq} '.download' )
  #       normal_upload=$( echo "$normal_result" | ${l.getExe pkgs.jq} '.upload' )
  #
  #       download_ratio_is_more_than_half=$( echo "$vpn_download / $normal_download > 0.5" | ${l.getExe pkgs.bc} -l | tr -d '\n' )
  #       upload_ratio_is_more_than_half=$( echo "$vpn_upload / $normal_upload > 0.5" | ${l.getExe pkgs.bc} -l | tr -d '\n' )
  #
  #       if [[ "$upload_ratio_is_more_than_half" == "0" || "$download_ratio_is_more_than_half" == "0" ]]; then
  #         echo "ratio is insufficient, restarting vpn"
  #         systemctl restart wg.service
  #         exit
  #       fi
  #       echo "ratio is sufficient"
  #     '';
  #   };
  # };

  # systemd.timers."wg-speedcheck" = {
  #   wantedBy = ["timers.target"];
  #   timerConfig = {
  #     OnCalendar = "0/2:00:00";
  #     Unit = "wg-speedcheck.service";
  #   };
  # };

  vpnNamespaces."wg" = {
    enable = true;
    wireguardConfigFile = config.sops.secrets.wireguard.path;
    accessibleFrom = [
      "192.168.0.0/24"
    ];

    # Forwarded to my vpn, for making things accessible from outside
    openVPNPorts = [
      {
        port = caddyPort;
        protocol = "tcp";
      }
      {
        port = config.services.slskd.settings.soulseek.listen_port;
        protocol = "both";
      }
      {
        port = config.services.transmission.settings.peer-port;
        protocol = "both";
      }
    ];

    # From inside of the vpn namespace to outside of it, for making things inside accessible to LAN
    portMappings = let
      passthrough = [
        caddyPort
        slskdUiPort
        1900 # jellyfin discovery
        7359 # jellyfin discovery
        config.services.transmission.settings.rpc-port
        80 # homepage
      ];
    in
      (l.map (x: {
          from = x;
          to = x;
        })
        passthrough)
      ++ [
      ];
  };

  networking.firewall = {
    allowedUDPPorts = [1900 7359]; # Jellyfin auto-discovery
    allowedTCPPorts = [
      # caddy lan ports
      80
      443
      2345
    ];
  };

  systemd.services.caddy.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.caddy = {
    enable = true;
    virtualHosts = builtins.mapAttrs (n: v:
      {
        useACMEHost = domain;
        hostName = "${n}.${domain}:${toString caddyPort}";
      }
      // v) {
      jellyfin.extraConfig = "reverse_proxy localhost:8096"; # TODO setup proper auth
      kanidm = {
        useACMEHost = null;
        # hostName = "kanidm.xunuwu.xyz:${toString caddyPort}";
        extraConfig = ''
          reverse_proxy https://127.0.0.1:${toString kanidmPort} {
            header_up Host {upstream_hostport}
            header_down Access-Control-Allow-Origin "*"
            transport http {
              tls_server_name ${config.services.kanidm.serverSettings.domain}
            }
          }
        '';
      };
      slskd = {
        useACMEHost = null;
        hostName = ":${toString slskdUiPort}";
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.slskd.settings.web.port}
        '';
      };
      dash = {
        useACMEHost = null;
        hostName = ":80";
        extraConfig = "reverse_proxy localhost:${toString config.services.homepage-dashboard.listenPort}";
      };
      # nextcloud.extraConfig = "reverse_proxy localhost:${toString ncPort}";
      other = {
        hostName = ":${toString caddyPort}";
        extraConfig = ''
          respond 404 {
            body "uhh that doesnt exist, i hope this isnt my fault.."
          }
        '';
      };
    };
  };

  # systemd.services.authentik.vpnConfinement = {
  #   enable = true;
  #   vpnNamespace = "wg";
  # };
  # services = {
  #   authentik = {
  #     enable = true;
  #     environmentFile = config.sops.secrets.authentik.path;
  #     settings = {
  #       disable_startup_analytics = true;
  #       avatars = "initials";
  #     };
  #   };
  #   authentik-ldap = {
  #     enable = true;
  #   };
  # };

  # services.keycloak = {
  #   enable = true;
  #   settings = {
  #     hostname = "keycloak.${domain}";
  #   };
  #   database.passwordFile = config.sops.secrets."keycloak/db".path;
  # };

  # needed for deploying secrets
  users.users.lldap = {
    group = "lldap";
    isSystemUser = true;
  };
  users.groups.lldap = {};

  services.lldap = {
    enable = true;
    environment = {
      LLDAP_JWT_SECRET_FILE = config.sops.secrets."lldap/jwt".path;
      LLDAP_LDAP_USER_PASS_FILE = config.sops.secrets."lldap/password".path;
    };
    settings = {
      ldap_base_dn = "dc=xunuwu,dc=xyz";
    };
  };

  # services.nextcloud = {
  #   enable = true;
  #   appstoreEnable = true;
  #   autoUpdateApps.enable = true;
  #   https = true;
  #   hostName = "localhost";
  #   package = pkgs.nextcloud30;
  #   database.createLocally = true;
  #   configureRedis = true;
  #   extraAppsEnable = true;
  #   extraApps = {
  #     inherit (config.services.nextcloud.package.packages.apps) calendar;
  #   };
  #
  #   config = {
  #     adminuser = "admin";
  #     adminpassFile = config.sops.secrets."nextcloud/admin_pass".path;
  #     dbtype = "pgsql";
  #     # commented so we just use the default sqlite
  #     # dbhost = "/run/postgresql";
  #     # dbtype = "pgsql";
  #   };
  #   settings = {
  #     default_phone_region = "SE";
  #     trusted_domains = ["127.0.0.1" "nextcloud.${domain}"];
  #   };
  # };

  # systemd.services.nginx.vpnConfinement = {
  #   enable = true;
  #   vpnNamespace = "wg";
  # };
  #
  # services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
  #   {
  #     addr = "127.0.0.1";
  #     port = ncPort; # NOT an exposed port
  #   }
  # ];

  # systemd.services.phpfpm-nextcloud.vpnConfinement = {
  #   enable = true;
  #   vpnNamespace = "wg";
  # };
  #
  # systemd.services.nextcloud-setup = {
  #   requires = ["postgresql.service"];
  #   after = ["postgresql.service"];
  # };

  systemd.services.homepage-dashboard.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.homepage-dashboard = {
    enable = true;
    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
        };
      }
    ];
    services = [
      {
        "Obtaining" = [
          {
            "transmission" = {
              href = "http://${config.networking.hostName}:9091";
              icon = "transmission";
            };
          }
          {
            "slskd" = {
              href = "http://${config.networking.hostName}:23488";
              icon = "slskd";
            };
          }
        ];
      }
      {
        "Services" = [
          {
            "jellyfin" = {
              href = "https://jellyfin.xunuwu.xyz";
              icon = "jellyfin";
            };
          }
          {
            "lldap" = {
              href = "http://${config.networking.hostName}:${toString config.services.lldap.settings.http_port}";
              icon = "lldap";
            };
          }
          # {
          #   "nextcloud" = {
          #     href = "https://nextcloud.xunuwu.xyz";
          #     icon = "nextcloud";
          #   };
          # }
        ];
      }
    ];
  };

  systemd.services.jellyfin.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.jellyfin = {
    enable = true;
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    extraFlags = ["--storage.tsdb.retention.time=30d"];
    scrapeConfigs = [
      {
        job_name = config.networking.hostName;
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
              "127.0.0.1:${toString config.services.prometheus.exporters.systemd.port}"
              # "127.0.0.1:${toString config.services.prometheus.exporters.wireguard.port}"
            ];
          }
        ];
      }
    ];
  };

  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = ["systemd"];
    };
    systemd.enable = true;
    # wireguard = {
    #   enable = true;
    #   wireguardConfig = config.sops.secrets.wireguard.path;
    # };
    # nextcloud = {
    #   enable = true;
    #   tokenFile = config.sops.secrets."prometheus/nextcloud".path;
    #   url = "https://nextcloud.${domain}";
    # };
  };

  systemd.services.slskd.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.slskd = {
    enable = true;
    environmentFile = config.sops.secrets.slskd.path;
    domain = null; # why isnt this the default?
    settings = {
      remote_file_management = true;
      shares.directories = ["/media/library/music"];
      soulseek = {
        listen_port = 14794;
        description = "";
      };
      global = {
        upload = {
          slots = 50;
          speed_limit = 10000;
        };
        download.speed_limit = 10000;
      };
    };
  };

  systemd.services.transmission.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    performanceNetParameters = true;
    settings = let
      mbit = 125;
    in {
      speed-limit-up-enabled = true;
      speed-limit-up = 100 * mbit;
      speed-limit-down-enabled = true;
      speed-limit-down = 150 * mbit;
      rpc-authentication-required = true;
      peer-port = 11936;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,192.168.\*.\*";
    };
    credentialsFile = config.sops.secrets.transmission.path;
  };

  # only used for samba
  users.groups.xun = {};
  users.users.xun = {
    isSystemUser = true;
    group = "xun";
    extraGroups = ["transmission" "vault" "media"];
  };

  users.groups.vault = {};
  systemd.tmpfiles.rules = [
    "d /srv/vault 0770 root vault -"
  ];
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "log level" = 6;
        "log file" = "/var/log/samba/samba.log";
        "server string" = config.networking.hostName;
        "hosts allow" = "192.168.50.0/24";
        "map to guest" = "bad user";
      };
      transmission = {
        path = "/var/lib/transmission";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "no";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
      vault = {
        path = "/srv/vault";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0660";
        "directory mask" = "0770";
        "force user" = "xun";
        "force group" = "xun";
      };
      slskd = {
        path = "/var/lib/slskd";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0660";
        "directory mask" = "0770";
        "force user" = "slskd";
        "force group" = "slskd";
      };
      library = {
        path = "media/library";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0666";
        "directory mask" = "0777";
        "force user" = "media";
        "force group" = "media";
      };
    };
  };

  # TODO use this for sso with some things maybe
  # services.tailscaleAuth = {
  #   enable = true;
  #   user = config.services.caddy.user;
  #   group = config.services.caddy.group;
  # };

  systemd.services.kanidm = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };
    serviceConfig = {
      InaccessiblePaths = lib.mkForce [];
    };
  };
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;
  services.kanidm = {
    package = pkgs.kanidm_1_4.override {enableSecretProvisioning = true;};
    enableServer = true;
    serverSettings = {
      domain = "kanidm.${domain}";
      origin = "https://kanidm.${domain}";
      bindaddress = "127.0.0.1:${toString kanidmPort}";
      ldapbindaddress = "[::1]:3636";
      trust_x_forward_for = true;
      tls_chain = "${config.security.acme.certs."kanidm.${domain}".directory}/fullchain.pem";
      tls_key = "${config.security.acme.certs."kanidm.${domain}".directory}/key.pem";
    };
    provision = {
      enable = true;
      adminPasswordFile = config.sops.secrets."kanidm/admin_pass".path;
      idmAdminPasswordFile = config.sops.secrets."kanidm/idm_admin_pass".path;
      persons = {
        "xun" = {
          displayName = "xun";
          legalName = "xun";
          mailAddresses = ["xunuwu@gmail.com"];
          groups = [];
        };
      };
    };
  };

  # systemd.services.kanidm = {
  #   vpnConfinement = {
  #     enable = true;
  #     vpnNamespace = "wg";
  #   };
  #   serviceConfig = {
  #     RestartSec = "60";
  #     SupplementaryGroups = [config.security.acme.certs.${domain}.group];
  #     PrivateNetwork = l.mkOverride 40 false;
  #     ProtectControlGroups = l.mkForce false;
  #     RestrictNamespaces = l.mkForce false;
  #     LockPersonality = l.mkForce false;
  #     CapabilityBoundingSet = l.mkForce [];
  #     # TemporaryFileSystem = l.mkForce [];
  #   };
  # };
  #
  # services.kanidm = {
  #   package = pkgs.kanidm.override {enableSecretProvisioning = true;};
  #
  #   enableServer = true;
  #   serverSettings = let
  #     subdomain = "kanidm";
  #     kdomain = "${subdomain}.${domain}";
  #     certDir = config.security.acme.certs.${domain}.directory;
  #   in {
  #     domain = kdomain;
  #     origin = "https://${kdomain}";
  #     bindaddress = "0.0.0.0:${toString kanidmPort}";
  #     # ldapbindaddress = "[::1]:636";
  #     trust_x_forward_for = true;
  #     tls_chain = "${certDir}/fullchain.pem";
  #     tls_key = "${certDir}/key.pem";
  #     ## TODO online_backup mayb
  #   };
  #
  #   provision = {
  #     enable = true;
  #
  #     adminPasswordFile = config.sops.secrets."kanidm/admin_pass".path;
  #     idmAdminPasswordFile = config.sops.secrets."kanidm/idm_admin_pass".path;
  #
  #     persons = let
  #       mainUser = "xun";
  #       mail = "xunuwu@gmail.com";
  #     in {
  #       ${mainUser} = {
  #         displayName = mainUser;
  #         legalName = mainUser;
  #         mailAddresses = [mail];
  #         groups = [
  #           "slskd.access"
  #           "slskd.admins"
  #         ];
  #       };
  #     };
  #
  #     groups = {
  #       "slskd.access" = {};
  #       "slskd.admins" = {};
  #     };
  #
  #     # systems.oath2 = {
  #     #   slskd = {
  #     #     displayName = "slskd";
  #     #     originUrl = "https://";
  #     #   };
  #     # };
  #   };
  # };
  ## TODO: add forgejo
}
