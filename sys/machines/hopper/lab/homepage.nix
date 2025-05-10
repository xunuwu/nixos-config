{
  config,
  vars,
  ...
}: let
  inherit (vars) domain;
  bridge = config.vpnNamespaces."wg".bridgeAddress;
in {
  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "dash.hopper.xun.host";
    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          uptime = "";
          units = "metric";
          cputemp = true;
          memory = true;
          network = true;
        };
      }
    ];
    services = [
      {
        "Downloading" = [
          {
            "transmission" = {
              href = "http://transmission.hopper.xun.host";
              icon = "transmission";
              widget = {
                type = "transmission";
                url = "http://${config.vpnNamespaces."wg".namespaceAddress}:${toString config.services.transmission.settings.rpc-port}";
              };
            };
          }
          {
            "slskd" = {
              href = "http://slskd.hopper.xun.host";
              icon = "slskd";
            };
          }
        ];
      }
      {
        "Services" = [
          {
            "jellyfin" = {
              href = "https://jellyfin.${domain}";
              icon = "jellyfin";
            };
          }
          {
            "navidrome" = {
              href = "https://navidrome.${domain}";
              icon = "navidrome";
            };
          }
          {
            "audiobookshelf" = {
              href = "https://abs.${domain}";
              icon = "audiobookshelf";
            };
          }
          {
            "adguard home" = {
              href = "http://adguard.hopper.xun.host";
              icon = "adguard-home";
              widget = {
                type = "adguard";
                url = "http://localhost:${toString config.services.adguardhome.port}";
              };
            };
          }
          {
            "prometheus" = {
              href = "http://prometheus.hopper.xun.host";
              icon = "prometheus";
              widget = {
                type = "prometheus";
                url = "http://localhost:${toString config.services.prometheus.port}";
              };
            };
          }
          {
            "vaultwarden" = {
              href = "https://vw.${domain}";
              icon = "vaultwarden";
            };
          }
        ];
      }
    ];
  };
}
