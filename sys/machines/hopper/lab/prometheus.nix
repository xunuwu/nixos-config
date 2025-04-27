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
        static_configs = lib.singleton {
          targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
        };
      }
      {
        job_name = "tailscale_client";
        static_configs = lib.singleton {
          targets = ["100.100.100.100"];
        };
      }
      {
        job_name = "caddy";
        static_configs = lib.singleton {
          targets = ["${config.vpnNamespaces."wg".namespaceAddress}:2019"];
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

  services.restic.backups.hopper.paths = ["/var/lib/prometheus2"];
}
