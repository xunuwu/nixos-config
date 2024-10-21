## TODO look into sops-nix placeholders
## reference: https://github.com/javigomezo/nixos/blob/b3ebe8d570ea9b37aea8bb3a343f6e16e054e322/services/network/authelia/user_database.nix
{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  domain = "xunuwu.xyz";
  caddyPort = 8336;
  autheliaPort = 24637;
in {
  ## TODO use impermanence
  ## TODO setup fail2ban mayb

  imports = [inputs.vpn-confinement.nixosModules.default];

  security.acme = {
    acceptTerms = true;
    certs.${domain} = {
      domain = "*.${domain}";
      dnsProvider = "cloudflare";
      email = "xunuwu@gmail.com";
      reloadServices = ["caddy.service"];
      credentialFiles.CF_DNS_API_TOKEN_FILE = config.sops.secrets.cloudflare.path;
      extraDomainNames = [domain];
    };
  };

  vpnNamespaces."wg" = {
    enable = true;
    wireguardConfigFile = config.sops.secrets.wireguard-config.path;
    accessibleFrom = [
      "192.168.0.0/24"
    ];

    # Forwarded to my vpn, for making things accessible from outside
    openVPNPorts = [
      {
        port = caddyPort;
        protocol = "tcp";
      }
    ];

    # From inside of the vpn namespace to outside of it, for making things inside accessible to LAN
    portMappings = [
      {
        to = caddyPort;
        from = caddyPort;
      }
      {
        to = 7359; # Jellyfin auto-discovery
        from = 7359;
      }
      {
        to = 1900; # Jellyfin auto-discovery, TODO check if this actually works and dont forward these if it doesnt
        from = 1900;
      }
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [config.services.navidrome.settings.Port];
    allowedUDPPorts = [1900 7359]; # Jellyfin auto-discovery
  };

  systemd.services.caddy.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.caddy = {
    enable = true;
    # extraConfig = let
    #   gensub = x: "${x}.${domain}:${toString caddyPort}";
    #   tls = "tls /var/lib/acme/${domain}/cert.pem /var/lib/acme/${domain}/key.pem";
    #   rpPort = port: "reverse_proxy localhost:${toString port}";
    # in ''
    #   ${gensub "navidrome"} {
    #     ${tls}
    #     ${rpPort config.services.navidrome.settings.Port}
    #   }
    # '';
    virtualHosts = let
      authelia = "localhost:${toString autheliaPort}";
    in
      builtins.mapAttrs (n: v:
        {
          useACMEHost = domain;
          hostName = "${n}.${domain}:${toString caddyPort}";
        }
        // v) {
        navidrome.extraConfig = ''
          reverse_proxy localhost:${toString config.services.navidrome.settings.Port}
        '';
        auth.extraConfig = "reverse_proxy ${authelia}";
        #jellyfin.extraConfig = "reverse_proxy localhost:8096"; # TODO tmp off since i dont have proper auth yet
        other = {
          hostName = ":${toString caddyPort}";
          extraConfig = ''
            respond 404 {
              body "no such route you dummy"
            }
          '';
        };
      };
  };

  systemd.services.navidrome = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };
    serviceConfig = {
      PrivateTmp = true;
      NoNewPrivileges = true;
      RestrictSUIDSGID = true;
      ProtectProc = "invisible";
    };
  };

  ## TODO might be unnecessary with authelia but specifying a custom PasswordEncryptionKey is recommended
  services.navidrome = {
    enable = true;
    settings = {
      Address = "localhost";
      MusicFolder = "/media/library/music";

      ReverseProxyWhitelist = "0.0.0.0/0"; # cant be accessed from outside since the navidrome port isnt mapped to outside of the wireguard namespace
    };
  };

  systemd.services.authelia-main = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };
    # serviceConfig.LoadCredential = [
    #   "users.yaml:${}"
    # ];
  };
  services.authelia.instances.main = {
    enable = true;
    secrets = {
      jwtSecretFile = config.sops.secrets.authelia_jwt_secret.path;
      storageEncryptionKeyFile = config.sops.secrets.authelia_encryption_key.path;
      sessionSecretFile = config.sops.secrets.authelia_session_secret.path;
    };
    settings = {
      # might change this to info in the future, for now its nice seeing debug messages if something goes wrong
      log.level = "debug";

      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = "*.${domain}";
            policy = "one_factor"; # using totp requires me to set up smtp support :(
          }
        ];
      };

      theme = "auto";
      default_2fa_method = "totp";
      ## use ldap backend, not yaml file
      ## https://www.authelia.com/configuration/first-factor/ldap/
      # default_redirection_url = "https://auth.${domain}/";

      notifier.filesystem.filename = "/tmp/authelia-notifier.txt"; ## TODO change this to something reasonable

      authentication_backend = {
        password_reset.disable = true;
        file.path = pkgs.writers.writeYAML "users.yaml" {
          users.xun = {
            disabled = false;
            displayname = "xun";
            password = "$argon2id$v=19$m=65536,t=3,p=4$cwYrForToKZn7+urMrSXuQ$PStkqPlo/7/GZ+hMsJXfOyZ0WijNtuZpaHWyZUuBWBY";
            email = "xunuwu@gmail.com";
            groups = ["admin"];
          };
        };
      };

      storage.postgres = {
        address = "unix:///run/postgresql";
        database = "authelia-main";
        # this isnt used, ensureDBOwnership allows us to auth to postgres using unix users
        username = "authelia-main";
        password = "unused";
      };

      session.cookies = [
        {
          domain = domain;
          authelia_url = "https://auth.${domain}";
          default_redirection_url = "https://invalid.${domain}"; # TODO replace with overview thing mayb
        }
      ];

      ## TODO: https://www.authelia.com/integration/proxies/forwarded-headers/#cloudflare

      server = {
        address = "127.0.0.1:${toString autheliaPort}";
        endpoints.authz.forward-auth.implementation = "ForwardAuth";
      };
    };
  };

  services.postgresql = let
    databases = ["authelia-main"];
  in {
    enable = true;
    ensureDatabases = databases;
    ensureUsers = lib.singleton {
      name = "authelia-main";
      ensureDBOwnership = true;
    };
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
            targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
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
  };

  # services.grafana = {
  #   enable = true;
  #   domain = "grafana.hopper";
  #   addr = "127.0.0.1";
  #   security = {
  #     adminUser = "admin";
  #     adminPasswordFile = config.sops.secrets.grafana-pass.path;
  #   };
  # };

  ## TODO: add forgejo

  ## ignore this its cringe and ill prob remove it later idk, its also pasted from someone else, idk who tho ##
  systemd.services.vpn-test-service = {
    enable = true;

    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };

    script = "${pkgs.writeShellApplication {
      name = "vpn-test";

      runtimeInputs = with pkgs; [util-linux unixtools.ping coreutils curl bash libressl netcat-gnu openresolv dig];

      text = ''
        cd "$(mktemp -d)"

        # DNS information
        dig google.com

        # Print resolv.conf
        echo "/etc/resolv.conf contains:"
        cat /etc/resolv.conf

        # Query resolvconf
        # echo "resolvconf output:"
        # resolvconf -l
        # echo ""

        # Get ip
        echo "Getting IP:"
        curl -s ipinfo.io

        echo -ne "DNS leak test:"
        curl -s https://raw.githubusercontent.com/macvk/dnsleaktest/b03ab54d574adbe322ca48cbcb0523be720ad38d/dnsleaktest.sh -o dnsleaktest.sh
        chmod +x dnsleaktest.sh
        ./dnsleaktest.sh
      '';
    }}/bin/vpn-test";
  };
}
