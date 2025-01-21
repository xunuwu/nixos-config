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
  adguardWebPort = 23489;
  kanidmPort = 8300;
  oauth2ProxyPort = 23490;
in {
  imports = [
    ./samba.nix
  ];

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

  vpnNamespaces."wg" = {
    enable = true;
    wireguardConfigFile = config.sops.secrets.wireguard.path;
    accessibleFrom = [
      "192.168.0.0/24"
      # "127.0.0.1"
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
        80 # caddy
        1900 # jellyfin discovery
        7359 # jellyfin discovery
        # 9001
      ];
    in (l.map (x: {
        from = x;
        to = x;
      })
      passthrough);
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
        hostName = "slskd.hopper.xun.host:80";
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.slskd.settings.web.port}
        '';
      };

      transmission = {
        useACMEHost = null;
        hostName = "transmission.hopper.xun.host:80";
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.transmission.settings.rpc-port}
        '';
      };
      dash = {
        useACMEHost = null;
        hostName = "dash.hopper.xun.host:80";
        extraConfig = "reverse_proxy localhost:${toString config.services.homepage-dashboard.listenPort}";
      };
      oauth2-proxy = {
        hostName = "oauth2.${domain}:${toString caddyPort}";
        extraConfig = "reverse_proxy unix//run/oauth2-proxy/oauth2-proxy.sock";
      };
      firefly = {
        useACMEHost = null;
        hostName = "firefly.hopper.xun.host:80";
        extraConfig = ''
          encode zstd gzip
          root * ${config.services.firefly-iii.package}/public
          php_fastcgi unix/${config.services.phpfpm.pools.firefly-iii.socket}
          file_server
        '';
      };
      # slskd-pub = {
      #   hostName = "slskd.${domain}:${toString caddyPort}";
      #   extraConfig = ''
      #     handle /oauth2/* {
      #       reverse_proxy unix//run/oauth2-proxy/oauth2-proxy.sock
      #     }
      #     handle {
      #       forward_auth unix//run/oauth2-proxy/oauth2-proxy.sock {
      #         uri /oauth2/auth
      #
      #         header_up X-Real-IP {remote_host}
      #
      #         @bad status 4xx
      #         handle_response @bad {
      #           redir * /oauth2/start
      #         }
      #       }
      #       reverse_proxy localhost:${toString config.services.slskd.settings.web.port}
      #     }
      #   '';
      # };
      # prometheus = {
      #   useACMEHost = null;
      #   hostName = "prometheus.hopper.xun.host:80";
      #   extraConfig = ''
      #     reverse_proxy ${toString config.vpnNamespaces."wg".bridgeAddress}:9001
      #   '';
      # };
      other = {
        hostName = ":${toString caddyPort}";
        extraConfig = ''
          respond 404 {
            body "uhh that doesnt exist, i hope this isnt my fault.."
          }
        '';
      };
      otherPriv = {
        useACMEHost = null;
        hostName = ":80";
        extraConfig = ''
          respond 404 {
            body "uhh that doesnt exist, i hope this isnt my fault.."
          }
        '';
      };
    };
  };

  # https://github.com/diogotcorreia/dotfiles/blob/f49cda185cef30d8150a08b60112766f4fc95813/hosts/hera/firefly-iii.nix#L19
  services.firefly-iii = {
    enable = true;
    virtualHost = "firefly.hopper.xun.host";
    group = config.services.caddy.group;
    settings = {
      DB_CONNECTION = "pgsql";
      APP_KEY_FILE = config.sops.secrets.firefly.path;
    };
  };
  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = config.services.firefly-iii.user;
        ensureDBOwnership = true;
        ensureClauses.login = true;
      }
    ];
    ensureDatabases = [config.services.firefly-iii.user];
  };
  services.firefly-iii-data-importer = {
    enable = true;
    group = config.services.caddy.group;
    settings = {
      FIREFLY_III_URL = config.services.firefly-iii.settings.APP_URL;
      FIREFLY_III_ACCESS_TOKEN = config.sops.secrets.firefly-data-importer.path;
    };
  };

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
          uptime = "";
          units = "metric";
          cputemp = true;
          memory = true;
          network = true;
        };
      }
    ];
    services = [
      {
        "Downloading" = [
          {
            "transmission" = {
              href = "http://transmission.hopper.xun.host";
              icon = "transmission";
            };
          }
          {
            "slskd" = {
              href = "http://slskd.hopper.xun.host";
              icon = "slskd";
            };
          }
        ];
      }
      {
        "Services" = [
          {
            "jellyfin" = {
              href = "https://jellyfin.${domain}";
              icon = "jellyfin";
            };
          }
          {
            "adguard home" = {
              href = "http://${config.networking.hostName}:${toString config.services.adguardhome.port}";
              icon = "adguard-home";
            };
          }
          {
            "prometheus" = {
              href = "http://${config.networking.hostName}:${toString config.services.prometheus.port}";
              icon = "prometheus";
            };
          }
          {
            "kanidm" = {
              href = "https://kanidm.${domain}";
              icon = "kanidm";
            };
          }
          {
            "firefly iii" = {
              href = "http://firefly.hopper.xun.host";
              icon = "firefly-iii";
            };
          }
        ];
      }
    ];
  };

  systemd.services.jellyfin.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.jellyfin.enable = true;

  services.prometheus = {
    enable = true;
    port = 9001;
    extraFlags = ["--storage.tsdb.retention.time=30d"];
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = lib.singleton {
          targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
        };
      }
      {
        job_name = "tailscale_client";
        static_configs = lib.singleton {
          targets = ["100.100.100.100"];
        };
      }
      # TODO figure out why i cant connect to slskd locally
      # {
      #   job_name = "slskd";
      #   static_configs = lib.singleton {
      #     targets = ["127.0.0.1:${toString slskdUiPort}"];
      #   };
      # }
    ];
  };

  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = ["systemd"];
    };
    systemd.enable = true;
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
      metrics = {
        enabled = true;
        authentication.disabled = true;
      };
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

  # TODO use this for sso with some things maybe
  # services.tailscaleAuth = {
  #   enable = true;
  #   user = config.services.caddy.user;
  #   group = config.services.caddy.group;
  # };

  # systemd.services.oauth2-proxy.vpnConfinement = {
  #   enable = true;
  #   vpnNamespace = "wg";
  # };

  systemd.services.oauth2-proxy = {
    after = ["kanidm.service"];
    serviceConfig = {
      RuntimeDirectory = "oauth2-proxy";
      UMask = "007";
    };
  };
  users.groups.oauth2-proxy.members = ["caddy"];

  services.oauth2-proxy = let
    clientID = "oauth2-proxy";
  in {
    enable = true;
    inherit clientID;
    cookie.expire = "24h";
    email.domains = ["*"];
    httpAddress = "unix:///run/oauth2-proxy/oauth2-proxy.sock";

    keyFile = config.sops.secrets.oauth2-proxy.path;

    reverseProxy = true;
    approvalPrompt = "auto";
    setXauthrequest = true;

    provider = "oidc";

    loginURL = "https://${config.services.kanidm.serverSettings.domain}/ui/oauth2";
    redeemURL = "https://${config.services.kanidm.serverSettings.domain}/oauth2/token";
    validateURL = "https://${config.services.kanidm.serverSettings.domain}/oauth2/openid/${clientID}/userinfo";
    oidcIssuerUrl = "https://${config.services.kanidm.serverSettings.domain}/oauth2/openid/${clientID}";

    # redeemURL = "https://${config.services.kanidm.serverSettings.domain}/oauth2/token";
    # loginURL = "https://${config.services.kanidm.serverSettings.domain}/ui/oauth2";
    # validateURL = "https://${config.services.kanidm.serverSettings.domain}/oauth2/openid/oauth2-proxy";
    # oidcIssuerUrl = "https://kanidm.${domain}/oauth2/openid/oauth2-proxy";
    # profileURL = "https://kanidm.${domain}/oauth2/openid/oauth2-proxy/userinfo";

    extraConfig = {
      code-challenge-method = "S256"; # PKCE
      #   oidc-issuer-url = "https://${config.services.kanidm.serverSettings.domain}";
      # insecure-oidc-skip-issuer-verification = "true";
      # insecure-oidc-allow-unverified-email = "true";
      # scope = "openid profile email groups";
    };
  };

  systemd.services.kanidm = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };
    serviceConfig = {
      InaccessiblePaths = lib.mkForce [];
    };
  };
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 99999999;
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
          groups = [
            "oauth2-proxy.access"
            "oauth2-proxy.adguardhome"
            "oauth2-proxy.analytics"
          ];
        };
      };

      groups."oauth2-proxy.access" = {};
      groups."oauth2-proxy.adguardhome" = {};
      # groups."oauth2-proxy.openwebui" = {};
      groups."oauth2-proxy.analytics" = {};
      systems.oauth2.oauth2-proxy = {
        displayName = "Oauth2 Proxy";
        originUrl = "https://oauth2.${domain}/oauth2/callback";
        originLanding = "https://oauth2.${domain}/";
        # basicSecretFile = config.age.secrets..path;
        preferShortUsername = true;
        scopeMaps."oauth2-proxy.access" = [
          "openid"
          "email"
        ];
        claimMaps.groups = {
          joinType = "array";
          valuesByGroup."oauth2-proxy.adguardhome" = ["access_adguardhome"];
          # valuesByGroup."oauth2-proxy.openwebui" = ["access_openwebui"];
          valuesByGroup."oauth2-proxy.analytics" = ["access_analytics"];
        };
      };
    };
  };

  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    port = adguardWebPort;
    # host = "100.115.105.144";
    settings = {
      dhcp.enabled = false;
      dns = {
        # port = adguardDnsPort;
        upstream_dns = [
          "quic://dns.nextdns.io"
          "https://cloudflare-dns.com/dns-query"
          "tls://unfiltered.adguard-dns.com"
          "https://dns10.quad9.net/dns-query"
        ];
        bind_hosts = ["100.115.105.144"];
        bootstrap_dns = ["1.1.1.1" "8.8.8.8"];
      };
      filtering = {
        rewrites = [
          {
            domain = "*.hopper.xun.host";
            answer = "100.115.105.144";
          }
          {
            domain = "hopper.xun.host";
            answer = "100.115.105.144";
          }
        ];
      };
      filters = [
        {
          name = "OISD (Big)";
          url = "https://big.oisd.nl";
          enabled = true;
        }
      ];
    };
  };

  ## TODO: add forgejo
}
