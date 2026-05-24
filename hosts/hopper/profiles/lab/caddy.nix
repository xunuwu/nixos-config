{
  config,
  vars,
  pkgs,
  inputs,
  ...
}: let
  inherit (vars) domain;
in {
  networking.firewall.allowedTCPPorts = [80 443];

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
    '';
    virtualHosts = let
      mkPublicEntry = name: destination: {
        hostName = "${name}.${domain}";
        useACMEHost = domain;
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
          @blocked not remote_ip 100.64.0.0/10
          respond @blocked "limited to intranet" 403
          reverse_proxy ${destination}
        '';
      };
    in {
      base = {
        hostName = "${domain}";
        useACMEHost = domain;
        extraConfig = ''
          root * ${inputs.own-website.packages.${pkgs.stdenv.hostPlatform.system}.default}
          file_server
        '';
      };

      navidrome = mkPublicEntry "navidrome" ":${toString config.services.navidrome.settings.Port}";
      vaultwarden = mkPublicEntry "vw" ":${toString config.services.vaultwarden.config.ROCKET_PORT}";
      abs = mkPublicEntry "abs" ":${toString config.services.audiobookshelf.port}";
      miniflux = mkPublicEntry "rss" ":18632";
      forgejo = {
        hostName = "git.${domain}";
        useACMEHost = domain;
        extraConfig = ''
          respond /metrics 403
          reverse_proxy localhost:${toString config.services.forgejo.settings.server.HTTP_PORT}
        '';
      };

      navidrome2 = mkPrivateEntry "navidrome" ":${toString config.services.navidrome.settings.Port}";
      slskd = mkPrivateEntry "slskd" ":${toString config.services.slskd.settings.web.port}";
      prometheus = mkPrivateEntry "prometheus" ":${toString config.services.prometheus.port}";
      # transmission = mkPrivateEntry "transmission" "localhost:${toString config.services.transmission.settings.rpc-port}";
      dash = mkPrivateEntry "dash" ":${toString config.services.homepage-dashboard.listenPort}";
      absPriv = mkPrivateEntry "abs" ":${toString config.services.audiobookshelf.port}";
      glances = mkPrivateEntry "glances" ":${toString config.services.glances.port}";
      alertmanager = mkPrivateEntry "alerts" ":${toString config.services.prometheus.alertmanager.port}";

      otherDomain = {
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
