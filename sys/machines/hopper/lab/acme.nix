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
        extraDomainNames = ["*.${domain}"];
        # dnsProvider = "porkbun";
        dnsProvider = "cloudflare";
        reloadServices = ["caddy.service"];
        credentialFiles = {
          CF_DNS_API_TOKEN_FILE = config.sops.secrets.cloudflare.path;
          # PORKBUN_API_KEY_FILE = config.sops.secrets.porkbun_api_key.path;
          # PORKBUN_SECRET_API_KEY_FILE = config.sops.secrets.porkbun_secret_key.path;
        };
      };
    };
  };

  environment.persistence."/persist".directories = ["/var/lib/acme"];
}
