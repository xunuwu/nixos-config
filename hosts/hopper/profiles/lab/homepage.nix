{
  config,
  vars,
  ...
}: let
  inherit (vars) domain;
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
            "alertmanager" = {
              href = "https://alerts.hopper.priv.${domain}";
              icon = "prometheus";
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
          {
            "miniflux" = {
              href = "https://rss.${domain}";
              icon = "miniflux";
            };
          }
          {
            "forgejo" = {
              href = "https://git.${domain}";
              icon = "forgejo";
            };
          }
        ];
      }
    ];
  };
}
