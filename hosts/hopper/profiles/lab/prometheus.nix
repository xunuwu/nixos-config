{
  lib,
  config,
  ...
}: {
  users.users."alertmanager" = {
    group = "alertmanager";
    isSystemUser = true;
  };
  users.groups."alertmanager" = {};

  systemd.services.alertmanager.serviceConfig.User = "alertmanager";
  systemd.services.alertmanager.serviceConfig.Group = "alertmanager";
  systemd.services.alertmanager.serviceConfig.DynamicUser = lib.mkForce "false";

  services.prometheus = {
    enable = true;
    port = 9001;
    extraFlags = ["--storage.tsdb.retention.time=30d"];
    alertmanager = {
      enable = true;
      configuration = {
        route = {
          group_by = ["alertname"];
          receiver = "discord";
        };
        receivers = lib.singleton {
          name = "discord";
          discord_configs = lib.singleton {
            webhook_url_file = config.sops.secrets.discord-webhook.path;
          };
        };
      };
    };
    alertmanagers = lib.singleton {
      scheme = "http";
      static_configs = lib.singleton {
        targets = ["localhost:${toString config.services.prometheus.alertmanager.port}"];
      };
    };
    rules = let
      megabyte = builtins.mul (1024 * 1024);
    in [
      ''
        groups:
          - name: disk
            rules:
            - alert: DiskSpaceLow
              expr: |
                node_filesystem_avail_bytes{fstype!~"(tmpfs|ramfs|fuse.*)"} / node_filesystem_size_bytes < 0.05
                OR
                node_filesystem_avail_bytes{fstype!~"(tmpfs|ramfs|fuse.*)"} < ${toString (megabyte 100)}
              for: 5m
              annotations:
                summary: "low disk space on {{ $labels.alias }} (mountpoint: {{ $labels.mountpoint }})"
          - name: systemd
            rules:
            - alert: FailedUnits
              expr: node_systemd_unit_state{state="failed"} == 1
              for: 5m
              annotations:
                summary: "service {{ $labels.name }} failed on {{ $labels.alias }}"
      ''
    ];
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
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
      };
      systemd.enable = true;
    };
  };

  environment.persistence."/persist".directories = ["/var/lib/prometheus2"];
  services.restic.backups.hopper.paths = ["/var/lib/prometheus2"];
}
