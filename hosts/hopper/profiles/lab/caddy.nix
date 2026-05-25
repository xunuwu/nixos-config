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

  services.oauth2-proxy = {
    enable = true;
    provider = "github";
    clientID = "Ov23liyloZzFlGif2QH5";
    keyFile = config.sops.secrets.oauth2-proxy.path;
    reverseProxy = true;

    email.domains = ["*"];
    cookie.domain = ".xunuwu.xyz";
    extraConfig = {
      whitelist-domain = "*.hopper.priv.xunuwu.xyz";
      github-user = ["xunuwu"]; # all allowed users
    };
  };

  systemd.services.caddy = {
    environment.CADDY_ADMIN = "localhost:2019";
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
          forward_auth localhost:4180 {
            uri /oauth2/auth
            header_up X-Real-IP {remote_host}

            @ua status 401

            # If oauth2-proxy says 401 (Unauthorized), redirect to the login portal
            handle_response @ua {
              redir * https://auth.xunuwu.xyz/oauth2/start?rd={scheme}://{host}{uri}
            }
          }

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

      auth = mkPublicEntry "auth" ":4180";
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

      slskd = mkPrivateEntry "slskd" ":${toString config.services.slskd.settings.web.port}";
      prometheus = mkPrivateEntry "prometheus" ":${toString config.services.prometheus.port}";
      # transmission = mkPrivateEntry "transmission" "localhost:${toString config.services.transmission.settings.rpc-port}";
      dash = mkPrivateEntry "dash" ":${toString config.services.homepage-dashboard.listenPort}";
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
