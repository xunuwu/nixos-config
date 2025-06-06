{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    config = {
      vo = "gpu-next";
      gpu-api = "vulkan";
      scale = "ewa_lanczos";
      deband = true;

      sub-auto = "fuzzy";
      slang = ["eng" "en"];

      save-position-on-quit = true;

      # update watch history
      ytdl-raw-options = "mark-watched=,cookies-from-browser=firefox";
    };
    profiles = {
      "extension.gif" = {
        cache = false;
        loop-file = true;
      };
      "protocol.https" = {
        cache-secs = 100;
        user-agent = "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/116.0";
      };
      "protocol.http" = {
        cache-secs = 100;
        user-agent = "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/116.0";
      };
    };
    scripts = with pkgs.mpvScripts; [
      cutter
    ];
  };
}
