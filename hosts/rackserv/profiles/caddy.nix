{
  vars,
  config,
  ...
}: let
  inherit (vars) domain;
  hopper = "10.0.0.2";
in {
  networking.firewall.allowedTCPPorts = [80 443];

  security.acme = {
    acceptTerms = true;
    defaults.email = "xunuwu@gmail.com";
    certs = {
      "${domain}" = {
        domain = "${domain}";
        extraDomainNames = ["*.${domain}"];
        dnsProvider = "cloudflare";
        reloadServices = ["caddy.service"];
        credentialFiles.CF_DNS_API_TOKEN_FILE = config.sops.secrets.cloudflare.path;
      };
    };
  };

  # systemd.services.caddy.environment.CADDY_ADMIN = "${vars.tailnet.rackserv}:2019";
  services.caddy = {
    enable = true;
    globalConfig = ''
      metrics {
        per_host
      }
      admin :2019 {
        origins 127.0.0.1 100.64.0.0/10
      }
    '';
    virtualHosts = let
      forgejoPort = toString config.services.forgejo.settings.server.HTTP_PORT;
    in {
      misc = {
        hostName = "${domain}";
        serverAliases = ["*.${domain}"];
        useACMEHost = domain;
        extraConfig = ''
          reverse_proxy ${hopper}
        '';
      };
      forgejo = {
        hostName = "git.${domain}";
        useACMEHost = domain;
        extraConfig = ''
          respond /metrics 403
          reverse_proxy localhost:${forgejoPort}
        '';
      };
      forgejoMetrics = {
        hostName = ":9615";
        extraConfig = ''
          @blocked {
            not {
              client_ip ${vars.tailnet.hopper}
              path /metrics
            }
          }
          respond @blocked 403
          reverse_proxy localhost:${forgejoPort}
        '';
      };
    };
  };
}
