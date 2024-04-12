{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./smbshare.nix
  ];
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerSocket.enable = true;
  };

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

          "127.0.0.1:8191:8191" # flaresolverr
          "9117:9117" # jackett
          "5030:5030" # slskd
          "8096:8096" # jellyfin
          "8080:8080" # qbittorrent webui
        ];

        environment = {
          VPN_SERVICE_PROVIDER = "airvpn";
          VPN_TYPE = "wireguard";
          SERVER_COUNTRIES = "Netherlands";
          FIREWALL_VPN_INPUT_PORTS = "11936,8096,14795";
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
      betanin = {
        image = "sentriz/betanin";
        environment = {
          UID = "1001";
          GID = "100";
        };
        ports = [
          "9393:9393"
        ];
        volumes = [
          "/media/config/betanin/data:/b/.local/share/betanin"
          "/media/config/betanin/config:/b/.config/betanin"
          "/media/config/betanin/beets:/b/.config/beets"
          "${config.sops.secrets.betanin.path}:/b/.config/beets/config.yaml"
          "/media/library/music:/music"
          "/media/slskd/downloads:/downloads"
        ];
      };
    };
  };
}
