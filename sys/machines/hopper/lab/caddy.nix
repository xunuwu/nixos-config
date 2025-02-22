{config, ...}: let
  domain = "xunuwu.xyz";
  caddyPort = 8336;
in {
  systemd.services.caddy.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      jellyfin = {
        useACMEHost = domain;
        hostName = "jellyfin.${domain}:${toString caddyPort}";
        extraConfig = ''
          reverse_proxy {
            header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}
            to localhost:8096
          }
        '';
      };
      navidrome = {
        useACMEHost = domain;
        hostName = "navidrome.${domain}:${toString caddyPort}";
        extraConfig = ''
          reverse_proxy unix//var/lib/navidrome/navidrome.sock
        '';
      };
      slskd = {
        hostName = "slskd.hopper.xun.host:80";
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.slskd.settings.web.port}
        '';
      };
      transmission = {
        hostName = "transmission.hopper.xun.host:80";
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.transmission.settings.rpc-port}
        '';
      };
      dash = {
        hostName = "dash.hopper.xun.host:80";
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.homepage-dashboard.listenPort}
        '';
      };
      vw = {
        useACMEHost = domain;
        hostName = "vw.${domain}:${toString caddyPort}";
        extraConfig = ''
          reverse_proxy {
            header_up X-Real-Ip {http.request.header.CF-Connecting-IP}
            to localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}
          }
        '';
      };
      other = {
        useACMEHost = domain;
        hostName = ":${toString caddyPort}";
        extraConfig = ''
          respond 404 {
            body "uhh that doesnt exist, i hope this isnt my fault.."
          }
        '';
      };
      otherPriv = {
        hostName = ":80";
        extraConfig = ''
          respond 404 {
            body "uhh that doesnt exist, i hope this isnt my fault.."
          }
        '';
      };
    };
  };
}
