{
  config,
  vars,
  ...
}: let
  inherit (vars.common) domain;
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
            "adguard home" = {
              href = "http://adguard.hopper.xun.host";
              icon = "adguard-home";
            };
          }
          {
            "prometheus" = {
              href = "http://prometheus.hopper.xun.host";
              icon = "prometheus";
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
