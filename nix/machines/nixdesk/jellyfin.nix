{config, ...}: {
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
        extraDomainNames = ["jellyfin.desktop.xun.cam"];
      };
    };
  };

  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerSocket.enable = true;
  };

  systemd.tmpfiles.rules = [
    "d /media/config/caddy/data 0750 root root -"
    "d /media/config/caddy/config 0750 root root -"
    "d /media/config/jellyfin/config 0750 root root -"
    "d /media/config/jellyfin/cache 0750 root root -"
    "d /media/library 0750 root root -"
  ];

  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      gluetun = {
        image = "qmcgaw/gluetun:v3";
        volumes = [
          "${config.sops.secrets.wireguard.path}:/gluetun/wireguard/wg0.conf"
        ];
        ports = [
          ## This bypasses the firewall
          ## use 127.0.0.1:XXXX:XXXX if you only want it to be accessible locally
          "8096:8096" # jellyfin local network
          "60926:60926" # jellyfin
        ];

        environment = {
          VPN_SERVICE_PROVIDER = "airvpn";
          VPN_TYPE = "wireguard";
          SERVER_COUNTRIES = "Netherlands";
          FIREWALL_VPN_INPUT_PORTS = "60926";
        };

        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--device=/dev/net/tun:/dev/net/tun"
        ];
      };
      jellyfin = {
        image = "jellyfin/jellyfin";
        volumes = [
          "/media/config/jellyfin/config:/config"
          "/media/config/jellyfin/cache:/cache"
          "/media/library:/library"
        ];
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
          "--device=/dev/dri:/dev/dri"
        ];
      };
      caddy = {
        image = "caddy";
        volumes = [
          "${builtins.toFile "Caddyfile" ''
            https://jellyfin.desktop.xun.cam:60926 {
              tls /etc/ssl/certs/xun.cam/cert.pem /etc/ssl/certs/xun.cam/key.pem
              reverse_proxy localhost:8096
            }
          ''}:/etc/caddy/Caddyfile"
          "/var/lib/acme/xun.cam:/etc/ssl/certs/xun.cam"
          "/media/config/caddy/data:/data"
          "/media/config/caddy/config:/config"
        ];
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
    };
  };
}
