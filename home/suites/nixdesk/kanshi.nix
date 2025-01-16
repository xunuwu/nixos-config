{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "default";
        profile.outputs = [
          {
            criteria = "DP-3";
            mode = "1920x1080@165Hz";
            position = "0,0";
          }
          {
            criteria = "HDMI-A-1";
            position = "1920,0";
          }
        ];
      }
    ];
  };
}
