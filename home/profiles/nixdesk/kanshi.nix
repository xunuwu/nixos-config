{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    profiles."default" = {
      outputs = [
        {
          # criteria = "AOC 27G2G3";
          criteria = "DP-3";
          mode = "1920x1080@165Hz";
        }
        {
          # criteria = "AOC 24B1W";
          criteria = "HDMI-A-1";
          position = "1920,0";
        }
      ];
    };
  };
}
