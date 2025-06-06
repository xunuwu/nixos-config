{pkgs, ...}: let
  musicDir = "/server/library/music";
  beetsDir = "/home/xun/beets";
in {
  programs.beets = {
    enable = true;
    package = pkgs.beets-unstable;
    settings = {
      directory = "${musicDir}/beets";
      library = "${beetsDir}/beets.db";

      import = {
        write = true;
        move = true;
        copy = false;

        autotag = true;
        confidence = 0.9;
        timid = true;
        group_albums = true;
      };

      original_date = true;

      plugins = ["lyrics" "missing" "unimported" "edit" "duplicates" "info"];

      lyrics = {
        synced = true; # prefer synced
        sources = ["lrclib" "genius" "google" "tekstowo"];
      };

      paths = {
        # default = "$albumartist/$album$year/$albumartist - $track - $title";
        default = "$albumartist/$album%aunique{}/$track $title";
        singleton = "single/$artist/$title";
        comp = "comp/$album%aunique{}/$track $title";
      };

      unimported.ignore_extensions = ["jpg" "png"];

      # threaded = true;
      # timeout = 5;
      # verbose = false;

      match = {
        strong_rec_thresh = 0.1;
        medium_rec_thresh = 0.25;
        rec_gap_thresh = 0.25;
        distance_weights = {
          source = 2.0;
          artist = 3.0;
          album = 3.0;
          media = 1.0;
          mediums = 1.0;
          year = 1.0;
          country = 0.5;
          label = 0.5;
          catalognum = 0.5;
          albumdisambig = 0.5;
          album_id = 5.0;
          tracks = 2.0;
          missing_tracks = 0.9;
          unmatched_tracks = 0.6;
          track_title = 3.0;
          track_artist = 2.0;
          track_index = 1.0;
          track_length = 2.0;
          track_id = 5.0;
        };
      };
    };
  };
}
