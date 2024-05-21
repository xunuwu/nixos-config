{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    #./smbshare.nix
  ];
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerSocket.enable = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "xunuwu@gmail.com";
      reloadServices = ["podman-caddy.service"];
    };
    certs = {
      "xun.cam" = {
        dnsProvider = "cloudflare";
        credentialFiles = {
          CF_DNS_API_TOKEN_FILE = config.sops.secrets.cloudflare.path;
        };
        extraDomainNames = [
          "jellyfin.xun.cam"
          "wakapi.xun.cam"
        ];
      };
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      gluetun = {
        image = "qmcgaw/gluetun:v3";
        volumes = [
          "${config.sops.secrets.wireguard.path}:/gluetun/wireguard/wg0.conf"
          #"${builtins.toFile "post-rules.txt" ''
          #  iptables -A INPUT -d 192.168.50.26 -p udp --sport
          #  ''}:/iptables/post-rules.txt"
        ];
        ports = [
          ## This bypasses the firewall
          ## use 127.0.0.1:XXXX:XXXX if you only want it to be accessible locally
          "127.0.0.1:1389:1389" # openldap
          "127.0.0.1:1636:1636" # openldap
          "127.0.0.1:8191:8191" # flaresolverr
          "9117:9117" # jackett
          "5030:5030" # slskd
          "8096:8096" # jellyfin
          "8080:8080" # qbittorrent webui
          #"80:8336" # caddy
          #"443:443" # caddy
          #"443:443/udp" # caddy
          "8336:8336" # jellyfin
        ];

        environment = {
          VPN_SERVICE_PROVIDER = "airvpn";
          VPN_TYPE = "wireguard";
          SERVER_COUNTRIES = "Netherlands";
          FIREWALL_VPN_INPUT_PORTS = "11936,8336,14795";
        };

        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--device=/dev/net/tun:/dev/net/tun"
        ];
      };
      qbittorrent = {
        image = "lscr.io/linuxserver/qbittorrent:latest";

        environment = {
          WEBUI_PORT = "8080";
          TORRENTING_PORT = "11936";
        };

        volumes = [
          "/media/config/qbittorrent:/config"
          "${config.sops.secrets.jackett.path}:/config/qBittorrent/nova3/engines/jackett.json"
          "/media/downloads:/downloads"
        ];

        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
      flaresolverr = {
        image = "flaresolverr/flaresolverr";
        environment = {
          LOG_LEVEL = "info";
        };
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
      jellyfin = {
        image = "jellyfin/jellyfin";
        volumes = [
          "/media/config/jellyfin/config:/config"
          "/media/config/jellyfin/cache:/cache"
          "/media/library:/library"
          "/media/downloads:/library/downloads"
        ];
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
      jackett = {
        image = "lscr.io/linuxserver/jackett:latest";
        volumes = [
          "/media/config/jackett:/config"
        ];
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
      slskd = {
        image = "slskd/slskd";
        volumes = [
          "/var/lib/slskd:/app"
          "/media/slskd/downloads:/downloads"
          "/media/slskd/incomplete:/incomplete"
          "/media/library/music:/shares/music"
          "${config.sops.secrets.slskd.path}:/app/slskd.yml"
        ];
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
      caddy = {
        image = "caddy";
        volumes = [
          #alt.xun.cam:8336 {
          #tls internal
          #reverse_proxy
          #localhost:5030
          #}
          "${builtins.toFile "Caddyfile" ''
            https://jellyfin.xun.cam:8336 {
              tls /etc/ssl/certs/xun.cam/cert.pem /etc/ssl/certs/xun.cam/key.pem
              reverse_proxy localhost:8096
            }
            https://wakapi.xun.cam:8336 {
              tls /etc/ssl/certs/xun.cam/cert.pem /etc/ssl/certs/xun.cam/key.pem
              reverse_proxy localhost:3000
            }
          ''}:/etc/caddy/Caddyfile"
          #tls /etc/ssl/certs/cloudflare/cert.pem /etc/ssl/certs/cloudflare/key.pem
          #"${config.sops.secrets.xun-cam-cert.path}:/etc/ssl/certs/cloudflare/cert.pem"
          #"${config.sops.secrets.xun-cam-key.path}:/etc/ssl/certs/cloudflare/key.pem"
          "/var/lib/acme/xun.cam:/etc/ssl/certs/xun.cam"
          "/media/config/caddy/data:/data"
          "/media/config/caddy/config:/config"
        ];
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
      #openldap = {
      #  image = "bitnami/openldap";
      #  environment = {
      #    "LDAP_ADMIN_USERNAME" = "admin";
      #    "LDAP_ADMIN_PASSWORD" = "adminpassword";
      #    "LDAP_USERS" = "user01,user02";
      #    "LDAP_PASSWORDS" = "password1,password2";
      #  };
      #  dependsOn = ["gluetun"];
      #  extraOptions = [
      #    "--network=container:gluetun"
      #  ];
      #};
      #authelia = {
      #  image = "authelia/authelia";
      #  environment = {
      #    AUTHELIA_JWT_SECRET_FILE = "/secrets/JWT_SECRET";
      #    AUTHELIA_SESSION_SECRET_FILE = "/secrets/SESSION_SECRET";
      #    AUTHELIA_STORAGE_POSTGRES_PASSWORD_FILE = "/secrets/STORAGE_PASSWORD";
      #    AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = "/secrets/STORAGE_ENCRYPTION_KEY";
      #  };
      #  volumes = [
      #    "${config.sops.secrets.authelia_jwt_secret.path}:/secrets/JWT_SECRET"
      #    "${config.sops.secrets.authelia_session_secret.path}:/secrets/SESSION_SECRET"
      #    "${config.sops.secrets.authelia_storage_password.path}:/secrets/STORAGE_PASSWORD"
      #    "${config.sops.secrets.authelia_encryption_key.path}:/secrets/STORAGE_ENCRYPTION_KEY"
      #    "${builtins.toFile "users_database.yml" ''
      #      them: auto
      #      default_redirection_url: https://auth.xun.cam:8336

      #      authentication_backend:
      #        ldap:
      #          address: 'ldap://127.0.0.1:1389'
      #          implementation: 'custom'
      #          timeout: '5s

      #      session:
      #        domain: example.com

      #        redis:
      #          host: redis
      #          port: 6379

      #      storage:
      #        postgres:
      #          host: database
      #          database: authelia
      #          username: authelia

      #      notifier:
      #        smtp:
      #          host: smtp.xun.cam
      #          port: 8336
      #          username: auth@xun.cam
      #          sender: "Authelia <auth@xun.cam"
      #    ''}:/config/configuration.yml"
      #    "${builtins.toFile "configuration.yml" ''
      #      them: auto
      #      default_redirection_url: https://auth.xun.cam:8336

      #      authentication_backend:
      #        file:
      #          path: /config/users_database.yml
      #      #authentication_backend:
      #      #  ldap:
      #      #    address: 'ldap://127.0.0.1:1389'
      #      #    implementation: 'custom'
      #      #    timeout: '5s

      #      session:
      #        domain: example.com

      #        redis:
      #          host: redis
      #          port: 6379

      #      storage:
      #        postgres:
      #          host: database
      #          database: authelia
      #          username: authelia

      #      notifier:
      #        smtp:
      #          host: smtp.xun.cam
      #          port: 8336
      #          username: auth@xun.cam
      #          sender: "Authelia <auth@xun.cam"
      #    ''}:/config/configuration.yml"
      #  ];
      #  dependsOn = ["gluetun"];
      #  extraOptions = [
      #    "--network=container:gluetun"
      #  ];
      #};
      betanin = {
        image = "sentriz/betanin";
        environment = {
          UID = "1000";
          GID = "1000";
        };
        ports = [
          "9393:9393"
        ];
        volumes = [
          "/media/config/betanin/data:/b/.local/share/betanin"
          "/media/config/betanin/config:/b/.config/betanin"
          "/media/config/betanin/beets:/b/.config/beets"
          "${config.sops.secrets.betanin.path}:/b/.config/beets/secrets.yaml"
          "${builtins.toFile "config.yaml" ''
            include:
              - secrets.yaml

            library: library.db
            directory: /music
            statefile: state.pickle

            threaded: yes

            import:
               write: yes
               copy: yes
               link: no
               move: no
               incremental: no

            paths:
               default: /$albumartist/$album %aunique{}/$track $title %aunique{}
               singleton: /$albumartist/$artist %aunique{}/$track $title %aunique{}
               comp: /Compilation/$album %aunique{}/$track $title %aunique{}
               albumtype:soundtrack: Soundtracks/$album %aunique{}/$track $title %aunique{}

            clutter: ["Thumbs.DB", ".DS_Store"]


            plugins: [
               embedart,
               fetchart,
               discogs,
               advancedrewrite,
               lyrics,
               spotify,
               scrub,
            ]

            genres: yes

            spotify:
              source_weight: 0.7

            advancesrewrite:
               artist GHOST: Ghost and Pals

            embedart:
               auto: yes
               ifempty: no
               remove_art_file: no

            fetchart:
               auto: yes
               cautious: yes
               minwidth: 500
               maxwidth: 1200
               cover_format: jpeg
               sources:
                  - coverart: release
                  - coverart: releasegroup
                  - albumart
                  - amazon
                  - google
                  - itunes
                  - fanarttv
                  - lastfm
                  - wikipedia

            lyrics:
               fallback: '''
               sources: musixmatch google

            replace:
                '[\\]':         '''
                '[_]':          '-'
                '[/]':          '-'
                '^\.':          '''
                '[\x00-\x1f]':  '''
                '[<>:"\?\*\|]': '''
                '\.$':          '''
                '\s+$':         '''
                '^\s+':         '''
                '^-':           '''
                '’':            "'"
                '′':            "'"
                '″':            '''
                '‐':            '-'

            aunique:
              keys: albumartist albumtype year album
              disambuguators: format mastering media label albumdisambig releasegroupdisambig
              bracket: '[]'
          ''}:/b/.config/beets/config.yaml"
          "/media/library/music:/music"
          "/media/slskd/downloads:/downloads/slskd"
          "/media/downloads/music:/downloads/torrent"
          "/media/config/betanin/import:/downloads/import"
        ];
      };
      wakapi = {
        image = "ghcr.io/muety/wakapi:latest";
        volumes = [
          "${config.sops.secrets.wakapi.path}:/app/config.yml"
          "/media/config/wakapi:/data" # needs to be chown 1000:1000
        ];
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
    };
  };
}
