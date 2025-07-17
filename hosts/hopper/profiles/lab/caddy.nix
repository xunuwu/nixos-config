{
  config,
  vars,
  ...
}: let
  inherit (vars) domain;
  bridge = config.vpnNamespaces."wg".bridgeAddress;
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
    globalConfig = ''
      metrics {
        per_host
      }
      servers {
        trusted_proxies static 10.0.0.1
      }
    '';
    virtualHosts = let
      mkPublicEntry = name: destination: {
        hostName = "${name}.${domain}:80";
        extraConfig = ''
          reverse_proxy {
            to ${destination}
          }
        '';
      };
      mkPrivateEntry = name: destination: {
        hostName = "${name}.hopper.priv.${domain}";
        useACMEHost = domain;
        extraConfig = ''
          @blocked not remote_ip ${bridge}
          respond @blocked "limited to intranet" 403
          reverse_proxy ${destination}
        '';
      };
    in {
      navidrome = mkPublicEntry "navidrome" "${bridge}:${toString config.services.navidrome.settings.Port}";
      vaultwarden = mkPublicEntry "vw" "${bridge}:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      abs = mkPublicEntry "abs" "${bridge}:${toString config.services.audiobookshelf.port}";
      miniflux = mkPublicEntry "rss" "${bridge}:18632";
      s3 = mkPublicEntry "s3" "unix//run/garage/s3.sock";
      s3-2 = mkPublicEntry "*.s3" "unix//run/garage/s3.sock";

      navidrome2 = mkPrivateEntry "navidrome" "${bridge}:${toString config.services.navidrome.settings.Port}";
      slskd = mkPrivateEntry "slskd" "localhost:${toString config.services.slskd.settings.web.port}";
      prometheus = mkPrivateEntry "prometheus" "${bridge}:${toString config.services.prometheus.port}";
      transmission = mkPrivateEntry "transmission" "localhost:${toString config.services.transmission.settings.rpc-port}";
      dash = mkPrivateEntry "dash" "${bridge}:${toString config.services.homepage-dashboard.listenPort}";
      absPriv = mkPrivateEntry "abs" "${bridge}:${toString config.services.audiobookshelf.port}";
      glances = mkPrivateEntry "glances" "${bridge}:${toString config.services.glances.port}";
      alertmanager = mkPrivateEntry "alerts" "${bridge}:${toString config.services.prometheus.alertmanager.port}";
      s3-web = mkPrivateEntry "s3-web" "unix//run/garage/web.sock";

      other = {
        hostName = "*.${domain}:80";
        extraConfig = ''
          respond 404 {
            body "uhh that doesnt exist, i hope this isnt my fault.."
          }
        '';
      };
    };
  };
}
