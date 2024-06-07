let
  musicDir = "/home/xun/music/library";
in {
  programs.beets = {
    enable = true;
    settings = {
      directory = "${musicDir}/data";
      library = "${musicDir}/beets/beets.db";
      import = {
        log = "${musicDir}/beets/import.log";
        incremental = true;
      };
      plugins = [
        "embedart"
        "fetchart"
        "discogs"
        #"advancedrewrite"
        "lyrics"
        "spotify"
        "scrub"
        "duplicates"
        "unimported"
      ];

      genres = true;

      spotify.source_weight = 0.7;

      embedart = {
        auto = true;
        ifempty = false;
        remove_art_file = false;
      };

      fetchart = {
        auto = true;
        cautious = true;
        minwidth = 500;
        maxwidth = 1200;
        cover_format = "jpeg";
        sources = [
          {"coverart" = "release";}
          {"coverart" = "releasegroup";}
          "albumart"
          "amazon"
          "google"
          "itunes"
          "fanarttv"
          "lastfm"
          "wikipedia"
        ];

        lyrics = {
          fallback = "''";
          sources = ["musicmatch" "google"];
        };

        replace = {
          "[\\\\]" = "'";
          "[_]" = "-";
          "[\\]" = "-";
          "^\\." = "'";
          "[\\x00-\\x1f]" = "'";
          "[<>:\"\\?\\*\\|]" = "'";
          "\\.$" = "'";
          "\\s+$" = "'";
          "^\\s+" = "'";
          "^-" = "'";
          "’" = "'";
          "′" = "'";
          "″" = "'";
          "‐" = "-";
        };

        aunique = {
          keys = ["albumartist" "albumtype" "year" "album"];
          disambuguators = ["format" "mastering" "media" "label" "albumdisambig" "releasegroupdisambig"];
          bracket = "[]";
        };
      };
    };
  };
}
