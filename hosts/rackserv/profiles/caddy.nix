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

  services.caddy = {
    enable = true;
    virtualHosts = {
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
          reverse_proxy localhost:${toString config.services.forgejo.settings.server.HTTP_PORT}
        '';
      };
      other = {
        extraConfig = ''
          respond 404
        '';
      };
    };
  };
}
