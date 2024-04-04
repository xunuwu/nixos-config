{config, ...}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "xun";
    group = "users";
    dataDir = "/home/xun/.local/share/syncthing";
    configDir = "/home/xun/.config/syncthing";

    overrideDevices = true;
    settings = {
      devices = {
        "nixdesk" = {
          id = "DZEIXRH-WBIEUUW-FFP2SLJ-BTIUPBE-YURLPN7-MUFOR6L-HS27D6G-I25XHQ3";
          autoAcceptFolders = true;
        };
        "redmi-note-10-pro" = {
          id = "MRAHIKH-TNHAKEG-OHMEFXI-BO54SXR-6IL2Y3B-3HVOWZF-ZGTS2OX-YSWTPQF";
          autoAcceptFolders = true;
        };
        "hopper" = {
          id = "DK3RPET-ACMULD2-TLQS6YM-XWUMS3N-JRNDNME-YTM3H4X-P7QVUKB-N3PL5QF";
          autoAcceptFolders = true;
        };
      };
      folders = {
        "~/secrets" = {
          devices = builtins.attrNames config.services.syncthing.settings.devices;
          id = "sfw9y-yusup";
        };
        "~/docs/xun-megavault" = {
          devices = builtins.attrNames config.services.syncthing.settings.devices;
          id = "1zkf-wf5r";
        };
      };
    };

    settings.options.urAccepted = -1; # disable usage reporting
    settings.gui.insecureSkipHostcheck = true;
    settings.gui.insecureAdminAccess = true;
  };
}
