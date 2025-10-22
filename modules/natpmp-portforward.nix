{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.own.natpmp-portforward;
in {
  options.own.natpmp-portforward = {
    enable = lib.mkEnableOption "enable natpmp port forwarding service";
    mappings = lib.types.listOf (lib.types.submodule {
      options = {
        public = lib.mkOption {
          type = lib.types.port;
        };
        private = lib.mkOption {
          type = lib.types.port;
        };
        protocol = lib.mkOption {
          default = "tcp";
          type = lib.types.enum [
            "tcp"
            "udp"
          ];
        };
      };
    });
  };

  config = lib.mkIf cfg.enable {
    systemd.services.natpmp-portforward = {
      requisite = ["network-online.target"];
      serviceConfig = {
        Restart = "on-failure";
        ExecStart = pkgs.writeScript "natpmp-portforward" ''
          #!${pkgs.bash}/bin/bash

          "${lib.concatMapStrings (x: ''
              ${pkgs.libnatpmp}/bin/natpmpc -a ${x.public} ${x.private} ${x.protocol} 60
            '')
            cfg.mappings}"
        '';
      };
    };

    systemd.timers.natpmp-portforward = {
      requires = ["network-online.target"];
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "1m";
        AccuracySec = "5s";
        Unit = "natpmp-portforward.service";
      };
    };
  };
}
