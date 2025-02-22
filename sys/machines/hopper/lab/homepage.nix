{config, ...}: {
  systemd.services.homepage-dashboard.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.homepage-dashboard = {
    enable = true;
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
              href = "https://jellyfin.xunuwu.xyz";
              icon = "jellyfin";
            };
          }
          {
            "navidrome" = {
              href = "https://navidrome.xunuwu.xyz";
              icon = "navidrome";
            };
          }
          {
            "adguard home" = {
              href = "http://${config.networking.hostName}:${toString config.services.adguardhome.port}";
              icon = "adguard-home";
            };
          }
          {
            "prometheus" = {
              href = "http://${config.networking.hostName}:${toString config.services.prometheus.port}";
              icon = "prometheus";
            };
          }
          {
            "vaultwarden" = {
              href = "https://vw.xunuwu.xyz";
              icon = "vaultwarden";
            };
          }
        ];
      }
    ];
  };
}
