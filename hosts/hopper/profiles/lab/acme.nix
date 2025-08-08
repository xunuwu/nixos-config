{
  config,
  vars,
  ...
}: let
  inherit (vars) domain;
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = "xunuwu@gmail.com";
    certs = {
      "${domain}" = {
        domain = "${domain}";
        extraDomainNames = ["*.${domain}" "*.hopper.priv.${domain}" "*.s3-web.hopper.priv.${domain}"];
        dnsProvider = "cloudflare";
        reloadServices = ["caddy.service"];
        credentialFiles = {
          CF_DNS_API_TOKEN_FILE = config.sops.secrets.cloudflare.path;
        };
      };
    };
  };

  environment.persistence."/persist".directories = ["/var/lib/acme"];
}
