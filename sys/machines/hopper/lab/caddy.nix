{
  config,
  vars,
  inputs,
  ...
}: let
  inherit (vars.common) domain;
  caddyPort = 8336;
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
    globalConfig = "metrics";
    virtualHosts = let
      mkPublicEntry = name: destination: {
        useACMEHost = domain;
        hostName = "${name}.${domain}:${toString caddyPort}";
        extraConfig = ''
          @blocked not remote_ip ${builtins.replaceStrings ["\n"] [" "] (builtins.foldl' (res: ip-ver: "${res} ${builtins.readFile inputs."cloudflare-${ip-ver}".outPath}") "" ["ipv4" "ipv6"])}
          respond @blocked "Access only allowed through cloudflare" 403
          reverse_proxy {
            header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}
            to ${destination}
          }
        '';
      };
      mkPrivateEntry = name: destination: {
        hostName = "${name}.hopper.xun.host:80";
        extraConfig = "reverse_proxy ${destination}";
      };
    in {
      jellyfin = mkPublicEntry "jellyfin" "${bridge}:8096";
      navidrome = mkPublicEntry "navidrome" "unix//var/lib/navidrome/navidrome.sock";
      vaultwarden = mkPublicEntry "vw" "${bridge}:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      abs = mkPublicEntry "abs" "${bridge}:${toString config.services.audiobookshelf.port}";

      slskd = mkPrivateEntry "slskd" "localhost:${toString config.services.slskd.settings.web.port}";
      prometheus = mkPrivateEntry "prometheus" "${bridge}:${toString config.services.prometheus.port}";
      adguard = mkPrivateEntry "adguard" "${bridge}:${toString config.services.adguardhome.port}";
      transmission = mkPrivateEntry "transmission" "localhost:${toString config.services.transmission.settings.rpc-port}";
      dash = mkPrivateEntry "dash" "${bridge}:${toString config.services.homepage-dashboard.listenPort}";
      absPriv = mkPrivateEntry "abs" "${bridge}:${toString config.services.audiobookshelf.port}";

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
