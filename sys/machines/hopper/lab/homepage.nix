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
    allowedHosts = "dash.hopper.priv.${domain}";
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
              href = "https://transmission.hopper.priv.${domain}";
              icon = "transmission";
              widget = {
                type = "transmission";
                url = "http://${config.vpnNamespaces."wg".namespaceAddress}:${toString config.services.transmission.settings.rpc-port}";
              };
            };
          }
          {
            "slskd" = {
              href = "https://slskd.hopper.priv.${domain}";
              icon = "slskd";
            };
          }
        ];
      }
      {
        "Services" = [
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
            "prometheus" = {
              href = "https://prometheus.hopper.priv.${domain}";
              icon = "prometheus";
              widget = {
                type = "prometheus";
                url = "http://localhost:${toString config.services.prometheus.port}";
              };
            };
          }
          {
            "glances" = {
              href = "https://glances.hopper.priv.${domain}";
              icon = "glances";
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
