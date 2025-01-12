let
  devices = {
    "nixdesk" = {
      id = "XXABQZC-CO6OM2E-EMB3QIJ-NF5I3WU-CCQPPRY-7BX4ZSS-WIU4WW2-WXFWVQR";
      autoAcceptFolders = true;
    };
    "redmi-note-10-pro" = {
      id = "WJPE56U-56LPOYB-IAENGSW-IFQ4A6J-66JX73I-ONXX4PY-QXJK6IF-UZHVWA7";
      autoAcceptFolders = true;
    };
    "hopper" = {
      id = "DK3RPET-ACMULD2-TLQS6YM-XWUMS3N-JRNDNME-YTM3H4X-P7QVUKB-N3PL5QF";
      autoAcceptFolders = true;
    };
    "school-probook" = {
      id = "ZYNRRWE-SIJLPMQ-5LJDWCY-BF5VMRM-FQRFEW4-L7PKA23-HVJADTV-FZYRSQM";
      autoAcceptFolders = true;
    };
  };
in {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "xun";
    group = "users";
    dataDir = "/home/xun/.local/share/syncthing";
    configDir = "/home/xun/.config/syncthing";

    overrideDevices = true;
    settings = {
      inherit devices;
      folders = {
        "~/secrets" = {
          devices = builtins.attrNames devices;
          versioning = {
            type = "trashcan";
            params.cleanoutDays = "180";
          };
          id = "sfw9y-yusup";
        };
        "~/docs/xun-megavault" = {
          devices = builtins.attrNames devices;
          id = "1zkf-wf5r";
          versioning = {
            type = "simple";
            params.keep = "15";
          };
        };
      };
    };

    settings.options.urAccepted = -1; # disable usage reporting
    settings.gui.insecureSkipHostcheck = true;
    settings.gui.insecureAdminAccess = true;
  };
}
