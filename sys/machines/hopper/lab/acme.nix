{config, ...}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "xunuwu@gmail.com";
    certs = {
      "xunuwu.xyz" = {
        domain = "*.xunuwu.xyz";
        dnsProvider = "cloudflare";
        reloadServices = ["caddy.service"];
        credentialFiles.CF_DNS_API_TOKEN_FILE = config.sops.secrets.cloudflare.path;
        extraDomainNames = ["xunuwu.xyz"];
      };
    };
  };
}
