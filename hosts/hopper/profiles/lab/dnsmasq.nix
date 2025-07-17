{
  vars,
  lib,
  ...
}: {
  systemd.services.dnsmasq.serviceConfig.after = ["tailscale"];

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      server = ["1.1.1.1" "8.8.8.8"];
      interface = ["tailscale0"];
      bind-interfaces = true;
      address = lib.mapAttrsToList (n: v: "/.${n}.priv.${vars.domain}/${v}") vars.tailnet;
    };
  };
}
