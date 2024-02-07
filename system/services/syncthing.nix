{
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
          id = "2WCEQPF-2J4U7IK-XRT25FV-NFT2JEM-AVOMDEK-FIJNZ24-7WCBZC2-57CX2AP";
          autoAcceptFolders = true;
        };
        "redmi-note-10-pro" = {
          id = "U6YYTHR-2ZXIEXQ-RNDERSF-CTVSP67-W24VK4Y-5EQRIV5-T7JJW2N-33L7XQV";
          autoAcceptFolders = true;
        };
        "hopper" = {
          id = "DK3RPET-ACMULD2-TLQS6YM-XWUMS3N-JRNDNME-YTM3H4X-P7QVUKB-N3PL5QF";
          autoAcceptFolders = true;
        };
      };
      folders = {
        "~/secrets" = {
          devices = [
            "nixdesk"
            "redmi-note-10-pro"
            "hopper"
          ];
          id = "sfw9y-yusup";
        };
      };
    };

    settings.options.urAccepted = -1; # disable usage reporting
    settings.gui.insecureSkipHostcheck = true;
    settings.gui.insecureAdminAccess = true;
  };
}
