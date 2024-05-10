{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    profiles."default" = {
      outputs = [
        {
          criteria = "DP-3";
          mode = "1920x1080@165Hz";
        }
        {
          criteria = "HDMI-A-1";
          position = "1920,0";
        }
      ];
    };
  };
}
