{
  config,
  vars,
  ...
}: let
  inherit (vars.common) domain;
  caddyPort = 8336;
in {
  systemd.services.caddy.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  systemd.services.caddy = {
    environment.CADDY_ADMIN = "0.0.0.0:2019";
    serviceConfig.RuntimeDirectory = "caddy";
  };

  services.caddy = {
    enable = true;
    globalConfig = "metrics";
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
      prometheus = {
        hostName = "prometheus.hopper.xun.host:80";
        extraConfig = ''
          reverse_proxy ${config.vpnNamespaces."wg".bridgeAddress}:${toString config.services.prometheus.port}
        '';
      };
      adguard = {
        hostName = "adguard.hopper.xun.host:80";
        extraConfig = ''
          reverse_proxy ${config.vpnNamespaces."wg".bridgeAddress}:${toString config.services.adguardhome.port}
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
