{inputs, ...}: {
  wayland.windowManager.sway.config.output = {
    "DP-3" = {
      mode = "1920x1080@165Hz";
      position = "1920 0";
      # allow_tearing = "yes";
      bg = "${inputs.wallpaper.outPath} fill";
    };
    "HDMI-A-1" = {
      position = "0 0";
    };
  };
}
