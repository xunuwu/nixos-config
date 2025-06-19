{
  lib,
  config,
  ...
}: {
  services.prometheus = {
    enable = true;
    port = 9001;
    extraFlags = ["--storage.tsdb.retention.time=30d"];
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = ["127.0.0.1:9100"];
            labels.alias = "hopper";
          }
          {
            targets = ["rackserv:9100"];
            labels.alias = "rackserv";
          }
        ];
      }
      {
        job_name = "tailscale_client";
        static_configs = lib.singleton {
          targets = ["100.100.100.100"];
        };
      }
      {
        job_name = "caddy";
        static_configs = [
          {
            targets = ["${config.vpnNamespaces."wg".namespaceAddress}:2019"];
            labels.alias = "hopper";
          }
          {
            targets = ["rackserv:2019"];
            labels.alias = "rackserv";
          }
        ];
      }
      {
        job_name = "slskd";
        static_configs = lib.singleton {
          targets = ["${config.vpnNamespaces."wg".namespaceAddress}:${toString config.services.slskd.settings.web.port}"];
        };
        metric_relabel_configs = lib.singleton {
          source_labels = ["__name__"];
          regex = "node_.*";
          action = "drop";
        };
      }
      {
        job_name = "forgejo";
        static_configs = lib.singleton {
          targets = ["rackserv:9615"];
        };
      }
    ];
  };

  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = ["systemd"];
    };
    systemd.enable = true;
  };

  environment.persistence."/persist".directories = ["/var/lib/prometheus2"];
  services.restic.backups.hopper.paths = ["/var/lib/prometheus2"];
}
