{
  vars,
  lib,
  ...
}: {
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    port = 23489;
    settings = {
      dhcp.enabled = false;
      dns = {
        upstream_dns = [
          "quic://dns.nextdns.io"
          "https://cloudflare-dns.com/dns-query"
          "tls://unfiltered.adguard-dns.com"
          "https://dns10.quad9.net/dns-query"
        ];
        bind_hosts = ["100.115.105.144"];
        bootstrap_dns = ["1.1.1.1" "8.8.8.8"];
      };
      filtering = {
        rewrites = lib.concatLists (lib.mapAttrsToList (n: v: [
            {
              domain = "${n}.xun.host";
              answer = v;
            }
            {
              domain = "*.${n}.xun.host";
              answer = v;
            }
          ])
          vars.tailnet);
      };
      filters = [
        {
          name = "OISD (Big)";
          url = "https://big.oisd.nl";
          enabled = true;
        }
      ];
    };
  };
}
