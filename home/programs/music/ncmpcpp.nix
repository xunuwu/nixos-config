{pkgs, ...}: {
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override {
      visualizerSupport = true;
      clockSupport = true;
    };
    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "J";
        command = ["select_item" "scroll_down"];
      }
      {
        key = "K";
        command = ["select_item" "scroll_up"];
      }
    ];
    settings = {
      ## Visualizer
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "Visualizer feed";
      visualizer_in_stereo = "yes";
      visualizer_type = "spectrum";
      visualizer_look = "●▮";

      ## Lyrics
      lyrics_fetchers = builtins.concatStringsSep "," [
        "musixmatch"
        "sing365"
        "metrolyrics"
        "justsomelyrics"
        "jahlyrics"
        "plyrics"
        "tekstowo"
        "zeneszoveg"
        "internet"
      ];
    };
  };
}
