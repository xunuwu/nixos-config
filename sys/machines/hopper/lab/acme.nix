{
  config,
  vars,
  ...
}: let
  inherit (vars.common) domain;
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = "xunuwu@gmail.com";
    certs = {
      "${domain}" = {
        domain = "${domain}";
        extraDomainNames = ["*.${domain}"];
        dnsProvider = "porkbun";
        reloadServices = ["caddy.service"];
        credentialFiles = {
          PORKBUN_API_KEY_FILE = config.sops.secrets.porkbun_api_key.path;
          PORKBUN_SECRET_API_KEY_FILE = config.sops.secrets.porkbun_secret_key.path;
        };
      };
    };
  };
}
