{
  lib,
  config,
  pkgs,
  ...
}: let
  hostname = config.networking.hostName;
  dashyConfig = {
    pageInfo = {
      #title = "Home Lab";
    };
    sections = [
      {
        name = "*arr";
        icon = "hl-servarr";
        items = [
          {
            title = "Sonarr";
            icon = "hl-sonarr";
            url = "http://${hostname}:8989";
          }
          {
            title = "Radarr";
            icon = "hl-radarr";
            url = "http://${hostname}:7878";
          }
          {
            title = "Prowlarr";
            icon = "hl-prowlarr";
            url = "http://${hostname}:9696";
          }
        ];
      }
      {
        name = "Management";
        items = [
          {
            title = "Jellyseerr";
            icon = "hl-jellyseerr";
            url = "http://${hostname}:5055";
          }
          {
            title = "Transmission";
            icon = "hl-transmission";
            url = "http://${hostname}:9091";
          }
        ];
      }
      {
        name = "Music";
        items = [
          {
            title = "Betanin";
            icon = "hl-betanin";
            url = "http://${hostname}:9393";
          }
          {
            title = "Slskd";
            icon = "hl-soulseek";
            url = "http://${hostname}:5030";
          }
        ];
      }
    ];
  };
in {
  imports = [
    #./statistics
  ];
  #virtualisation.docker = {
  #  enable = true;
  #  enableOnBoot = true;
  #  autoPrune.enable = true;
  #};

  systemd.tmpfiles.rules = [
    "d /var/lib/code-server 0750 root root -"
    "d /var/lib/slskd 0750 root root -"
  ];

  users.groups."media" = {}; # create media group

  # this needs to be done manually since transmission is in a docker container
  users.users."media" = {
    isSystemUser = true;
    group = "media";
  };

  systemd.services."${config.virtualisation.oci-containers.backend}-transmission".serviceConfig = {
    StateDirectory = [
      "${config.virtualisation.oci-containers.backend}/transmission/downloads"
      "${config.virtualisation.oci-containers.backend}/transmission/config"
      "${config.virtualisation.oci-containers.backend}/transmission/watch"
    ];
  };

  #security.acme = {
  #  acceptTerms = true;
  #  defaults.email = "xunuwu@gmail.com";
  #  certs."air.xun.cam" = {
  #    dnsProvider = "cloudflare";
  #    credentialsFile = config.sops.secrets.cloudflare.path;
  #  };
  #};

  #systemd.services."${config.virtualisation.oci-containers.backend}-jellyfin".serviceConfig = {
  #  StateDirectory = [
  #    "${config.virtualisation.oci-containers.backend}/jellyfin/config"
  #    "${config.virtualisation.oci-containers.backend}/jellyfin/cache"
  #    "${config.virtualisation.oci-containers.backend}/jellyfin/media"
  #  ];
  #};

  #services.jellyfin = {
  #  enable = true;
  #  openFirewall = true;
  #  group = "media";
  #};

  #services.radarr = {
  #  enable = true;
  #  group = "media";
  #  openFirewall = true; # 7878
  #};

  #services.sonarr = {
  #  enable = true;
  #  group = "media";
  #  openFirewall = true; # 8989
  #};

  #services.prowlarr = {
  #  enable = true;
  #  openFirewall = true; # 9696
  #};

  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerSocket.enable = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      gluetun = {
        image = "qmcgaw/gluetun:v3";

        volumes = [
          "${config.sops.secrets.wireguard.path}:/gluetun/wireguard/wg0.conf"
        ];

        ports = [
          # Transmission port
          ## This bypasses the firewall, use 127.0.0.1:XXXX:XXXX
          ## if you only want it to be accessible locally
          "9091:9091"
          "127.0.0.1:8191:8191" # flaresolverr
          "9696:9696" # prowlarr
          "8989:8989" # sonarr
          "7878:7878" # radarr
          #"8443:8443" # code-server
          "5030:5030" # slskd
          "5031:5031" # slskd https
          "8096:8096" # jellyfin
        ];

        environment = {
          VPN_SERVICE_PROVIDER = "airvpn";
          VPN_TYPE = "wireguard";
          SERVER_COUNTRIES = "Netherlands";
          FIREWALL_VPN_INPUT_PORTS = "11936,8096,14795";
        };

        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--device=/dev/net/tun:/dev/net/tun"
        ];
      };

      slskd = {
        image = "slskd/slskd";
        volumes = [
          "/var/lib/slskd:/app"
          "/media/slskd/downloads:/downloads"
          "/media/slskd/incomplete:/incomplete"
          "/media/library/music:/shares/music"
          "${config.sops.secrets.slskd.path}:/app/slskd.yml"
        ];
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };

      beets = {
        image = "lscr.io/linuxserver/beets:latest";
        volumes = [
          "/media/config/beets:/config"
          "/media/library/music:/music"
          "/media/slskd/downloads:/downloads"
        ];
      };

      jellyfin = {
        image = "jellyfin/jellyfin";
        volumes = [
          "/media/config/jellyfin/config:/config"
          "/media/config/jellyfin/cache:/cache"
          "/media/library:/library"
        ];
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };

      #betanin = {
      #  image = "sentriz/betanin";
      #  ports = [
      #    "9393:9393"
      #  ];
      #  volumes = [
      #    "/media/config/betanin/data:/b/.local/share/betanin"
      #    "/media/config/betanin/config:/b/.config/betanin"
      #    "/media/config/betanin/beets:/b/.config/beets/"
      #    "${pkgs.writeText "config.yaml" ''
      #      # --------------- Main ---------------
      #
      #      library: library.db
      #      directory: /music
      #      statefile: state.pickle
      #
      #      # --------------- Plugins ---------------
      #
      #      plugins: []
      #      pluginpath: []
      #
      #      # --------------- Import ---------------
      #
      #      clutter: ["Thumbs.DB", ".DS_Store"]
      #      ignore: [".*", "*~", "System Volume Information", "lost+found"]
      #      ignore_hidden: yes
      #
      #      import:
      #          # common options
      #          write: yes
      #          copy: yes
      #          move: no
      #          timid: no
      #          quiet: no
      #          log:
      #          # other options
      #          default_action: apply
      #          languages: []
      #          quiet_fallback: skip
      #          none_rec_action: ask
      #          # rare options
      #          link: no
      #          hardlink: no
      #          reflink: no
      #          delete: no
      #          resume: ask
      #          incremental: no
      #          incremental_skip_later: no
      #          from_scratch: no
      #          autotag: yes
      #          singletons: no
      #          detail: no
      #          flat: no
      #          group_albums: no
      #          pretend: false
      #          search_ids: []
      #          duplicate_keys:
      #              album: albumartist album
      #              item: artist title
      #          duplicate_action: ask
      #          duplicate_verbose_prompt: no
      #          bell: no
      #          set_fields: {}
      #          ignored_alias_types: []
      #          singleton_album_disambig: yes
      #
      #      # --------------- Paths ---------------
      #
      #      path_sep_replace: _
      #      drive_sep_replace: _
      #      asciify_paths: false
      #      art_filename: cover
      #      max_filename_length: 0
      #      replace:
      #          # Replace bad characters with _
      #          # prohibited in many filesystem paths
      #          '[<>:\?\*\|]': _
      #          # double quotation mark "
      #          '\"': _
      #          # path separators: \ or /
      #          '[\\/]': _
      #          # starting and closing periods
      #          '^\.': _
      #          '\.$': _
      #          # control characters
      #          '[\x00-\x1f]': _
      #          # dash at the start of a filename (causes command line ambiguity)
      #          '^-': _
      #          # Replace bad characters with nothing
      #          # starting and closing whitespace
      #          '\s+$': ''\'''\'
      #          '^\s+': ''\'''\'
      #
      #      aunique:
      #          keys: albumartist album
      #          disambiguators: albumtype year label catalognum albumdisambig releasegroupdisambig
      #          bracket: '[]'
      #
      #      sunique:
      #          keys: artist title
      #          disambiguators: year trackdisambig
      #          bracket: '[]'
      #
      #      # --------------- Tagging ---------------
      #
      #      per_disc_numbering: no
      #      original_date: no
      #      artist_credit: no
      #      id3v23: no
      #      va_name: "Various Artists"
      #      paths:
      #          default: $albumartist/$album%aunique{}/$track $title
      #          singleton: Non-Album/$artist/$title
      #          comp: Compilations/$album%aunique{}/$track $title
      #
      #      # --------------- Performance ---------------
      #
      #      threaded: yes
      #      timeout: 5.0
      #
      #      # --------------- UI ---------------
      #
      #      verbose: 0
      #      terminal_encoding:
      #
      #      ui:
      #          terminal_width: 80
      #          length_diff_thresh: 10.0
      #          color: yes
      #          colors:
      #              text_success: ['bold', 'green']
      #              text_warning: ['bold', 'yellow']
      #              text_error: ['bold', 'red']
      #              text_highlight: ['bold', 'red']
      #              text_highlight_minor: ['white']
      #              action_default: ['bold', 'cyan']
      #              action: ['bold', 'cyan']
      #              # New Colors
      #              text: ['normal']
      #              text_faint: ['faint']
      #              import_path: ['bold', 'blue']
      #              import_path_items: ['bold', 'blue']
      #              added:   ['green']
      #              removed: ['red']
      #              changed: ['yellow']
      #              added_highlight:   ['bold', 'green']
      #              removed_highlight: ['bold', 'red']
      #              changed_highlight: ['bold', 'yellow']
      #              text_diff_added:   ['bold', 'red']
      #              text_diff_removed: ['bold', 'red']
      #              text_diff_changed: ['bold', 'red']
      #              action_description: ['white']
      #          import:
      #              indentation:
      #                  match_header: 2
      #                  match_details: 2
      #                  match_tracklist: 5
      #              layout: column
      #
      #      # --------------- Search ---------------
      #
      #      format_item: $artist - $album - $title
      #      format_album: $albumartist - $album
      #      time_format: '%Y-%m-%d %H:%M:%S'
      #      format_raw_length: no
      #
      #      sort_album: albumartist+ album+
      #      sort_item: artist+ album+ disc+ track+
      #      sort_case_insensitive: yes
      #
      #      # --------------- Autotagger ---------------
      #
      #      overwrite_null:
      #        album: []
      #        track: []
      #      musicbrainz:
      #          enabled: yes
      #          host: musicbrainz.org
      #          https: no
      #          ratelimit: 1
      #          ratelimit_interval: 1.0
      #          searchlimit: 5
      #          extra_tags: []
      #          genres: no
      #          external_ids:
      #              discogs: no
      #              bandcamp: no
      #              spotify: no
      #              deezer: no
      #              beatport: no
      #              tidal: no
      #
      #      match:
      #          strong_rec_thresh: 0.04
      #          medium_rec_thresh: 0.25
      #          rec_gap_thresh: 0.25
      #          max_rec:
      #              missing_tracks: medium
      #              unmatched_tracks: medium
      #          distance_weights:
      #              source: 2.0
      #              artist: 3.0
      #              album: 3.0
      #              media: 1.0
      #              mediums: 1.0
      #              year: 1.0
      #              country: 0.5
      #              label: 0.5
      #              catalognum: 0.5
      #              albumdisambig: 0.5
      #              album_id: 5.0
      #              tracks: 2.0
      #              missing_tracks: 0.9
      #              unmatched_tracks: 0.6
      #              track_title: 3.0
      #              track_artist: 2.0
      #              track_index: 1.0
      #              track_length: 2.0
      #              track_id: 5.0
      #          preferred:
      #              countries: []
      #              media: []
      #              original_year: no
      #          ignored: []
      #          required: []
      #          ignored_media: []
      #          ignore_data_tracks: yes
      #          ignore_video_tracks: yes
      #          track_length_grace: 10
      #          track_length_max: 30
      #          album_disambig_fields: data_source media year country label catalognum albumdisambig
      #          singleton_disambig_fields: data_source index track_alt album
      #    ''}:/b/.config/beets/config.yaml"
      #    "/media/music:/music"
      #    "/media/slskd/downloads:/downloads"
      #  ];
      #};

      #beets = {
      #  image = "lscr.io/linuxserver/beets:latest";
      #  volumes = [
      #    "/media/config/beets:/config"
      #    "/media/music:/music"
      #    "/media/slskd/downloads:/downloads"
      #  ];
      #};

      code-server = {
        image = "lscr.io/linuxserver/code-server:latest";
        volumes = [
          "/var/lib/code-server:/config"
        ];
        environmentFiles = [
          config.sops.secrets.code-server.path
        ];
        dependsOn = ["gluetun"];
        extraOptions = [
          #"--group-add ${config.security.acme.defaults.group}"
          "--network=container:gluetun"
        ];
      };

      #jellyseerr = {
      #  image = "fallenbagel/jellyseerr:latest";
      #  ports = [
      #    "5055:5055"
      #  ];
      #  volumes = [
      #    "/media/config/jellyseerr:/app/config"
      #  ];
      #  extraOptions = [
      #    "--network=host"
      #  ];
      #};

      recyclarr = {
        image = "ghcr.io/recyclarr/recyclarr";
        volumes = [
          #"/media/config/recyclarr:/config"
          "${pkgs.writeText "recyclarr.yml" ''
            sonarr:
              sonarr-main:
                base_url: http://localhost:8989
                api_key: !env_var SONARR_API_KEY
                delete_old_custom_formats: true
                replace_existing_custom_formats: true
                quality_definition:
                  type: series
                custom_formats:
                  - trash_ids:
                      # Unwanted
                      - 85c61753df5da1fb2aab6f2a47426b09 # BR-DISK
                      - 9c11cd3f07101cdba90a2d81cf0e56b4 # LQ
                      - 47435ece6b99a0b477caf360e79ba0bb # x265
                      # Misc
                      - ec8fa7296b64e8cd390a1600981f3923 # Repack/Proper
                      - eb3d5cc0a2be0db205fb823640db6a3c # Repack v2
                      - 44e7c4de10ae50265753082e5dc76047 # Repack v3
                      # Streaming Services
                      - d660701077794679fd59e8bdf4ce3a29 # AMZN
                      - f67c9ca88f463a48346062e8ad07713f # ATVP
                      - 36b72f59f4ea20aad9316f475f2d9fbb # DCU
                      - 89358767a60cc28783cdc3d0be9388a4 # DNSP
                      - 7a235133c87f7da4c8cccceca7e3c7a6 # HBO
                      - a880d6abc21e7c16884f3ae393f84179 # HMAX
                      - f6cce30f1733d5c8194222a7507909bb # HULU
                      - 0ac24a2a68a9700bcb7eeca8e5cd644c # iT
                      - d34870697c9db575f17700212167be23 # NF
                      - b2b980877494b560443631eb1f473867 # NLZ
                      - 1656adc6d7bb2c8cca6acfb6592db421 # PCOK
                      - c67a75ae4a1715f2bb4d492755ba4195 # PMTP
                      - 3ac5d84fce98bab1b531393e9c82f467 # QIBI
                      - c30d2958827d1867c73318a5a2957eb1 # RED
                      - ae58039e1319178e6be73caab5c42166 # SHO
                      - 1efe8da11bfd74fbbcd4d8117ddb9213 # STAN
                      - 5d2317d99af813b6529c7ebf01c83533 # VDL
                      - 77a7b25585c18af08f60b1547bb9b4fb # CC
                      # HQ Source Groups
                      - e6258996055b9fbab7e9cb2f75819294 # WEB Tier 01
                      - 58790d4e2fdcd9733aa7ae68ba2bb503 # WEB Tier 02
                      - d84935abd3f8556dcd51d4f27e22d0a6 # WEB Tier 03
                      - d0c516558625b04b363fa6c5c2c7cfd4 # WEB Scene
                    quality_profiles:
                      - name: TRaSH 720/1080
                  - trash_ids:
                      - 949c16fe0a8147f50ba82cc2df9411c9 # Anime BD Tier 01 (Top SeaDex Muxers)
                      - ed7f1e315e000aef424a58517fa48727 # Anime BD Tier 02 (SeaDex Muxers)
                      - 096e406c92baa713da4a72d88030b815 # Anime BD Tier 03 (SeaDex Muxers)
                      - 30feba9da3030c5ed1e0f7d610bcadc4 # Anime BD Tier 04 (SeaDex Muxers)
                      - 545a76b14ddc349b8b185a6344e28b04 # Anime BD Tier 05 (Remuxes)
                      - 25d2afecab632b1582eaf03b63055f72 # Anime BD Tier 06 (FanSubs)
                      - 0329044e3d9137b08502a9f84a7e58db # Anime BD Tier 07 (P2P/Scene)
                      - c81bbfb47fed3d5a3ad027d077f889de # Anime BD Tier 08 (Mini Encodes)
                      - e0014372773c8f0e1bef8824f00c7dc4 # Anime Web Tier 01 (Muxers)
                      - 19180499de5ef2b84b6ec59aae444696 # Anime Web Tier 02 (Top FanSubs)
                      - e6258996055b9fbab7e9cb2f75819294 # WEB Tier 01
                      - 58790d4e2fdcd9733aa7ae68ba2bb503 # WEB Tier 02
                      - c27f2ae6a4e82373b0f1da094e2489ad # Anime Web Tier 03 (Official Subs)
                      - d84935abd3f8556dcd51d4f27e22d0a6 # WEB Tier 03
                      - 4fd5528a3a8024e6b49f9c67053ea5f3 # Anime Web Tier 04 (Official Subs)
                      - 29c2a13d091144f63307e4a8ce963a39 # Anime Web Tier 05 (FanSubs)
                      - dc262f88d74c651b12e9d90b39f6c753 # Anime Web Tier 06 (FanSubs)
                      # Unwanted
                      - b4a1b3d705159cdca36d71e57ca86871 # Anime Raws
                      - e3515e519f3b1360cbfc17651944354c # Anime LQ Groups
                      - 15a05bc7c1a36e2b57fd628f8977e2fc # AV1
                      - 026d5aadd1a6b4e550b134cb6c72b3ca # Uncensored
                      - d2d7b8a9d39413da5f44054080e028a3 # v0
                      - 9c14d194486c4014d422adc64092d794 # Dubs Only
                      - 07a32f77690263bb9fda1842db7e273f # VOSTFR
                      # Optionals
                      - 273bd326df95955e1b6c26527d1df89b # v1
                      - 228b8ee9aa0a609463efca874524a6b8 # v2
                      - 0e5833d3af2cc5fa96a0c29cd4477feb # v3
                      - 4fc15eeb8f2f9a749f918217d4234ad8 # v4
                      - b2550eb333d27b75833e25b8c2557b38 # 10bit
                      # Streaming Services
                      - d660701077794679fd59e8bdf4ce3a29 # AMZN
                      - 7dd31f3dee6d2ef8eeaa156e23c3857e # B-Global
                      - 4c67ff059210182b59cdd41697b8cb08 # Bilibili
                      - 3e0b26604165f463f3e8e192261e7284 # CR
                      - 89358767a60cc28783cdc3d0be9388a4 # DSNP
                      - 1284d18e693de8efe0fe7d6b3e0b9170 # FUNi
                      - 570b03b3145a25011bf073274a407259 # HIDIVE
                      - d34870697c9db575f17700212167be23 # NF
                      - 44a8ee6403071dd7b8a3a8dd3fe8cb20 # VRV
                    quality_profiles:
                      - name: TRaSH Anime
                  - trash_ids:
                      - 418f50b10f1907201b6cfdf881f467b7 # Anime Dual Audio
                    quality_profiles:
                      - name: TRaSH Anime
                        score: 2000
            radarr:
              radarr-main:
                base_url: http://localhost:7878
                api_key: !env_var RADARR_API_KEY
                quality_definition:
                  type: movie
                delete_old_custom_formats: true
                replace_existing_custom_formats: true
                custom_formats:
                  - trash_ids:
                      # HD Bluray + WEB
                      # Movie Versions
                      - 0f12c086e289cf966fa5948eac571f44 # Hybrid
                      - 570bc9ebecd92723d2d21500f4be314c # Remaster
                      - eca37840c13c6ef2dd0262b141a5482f # 4K Remaster
                      - e0c07d59beb37348e975a930d5e50319 # Criterion Collection
                      - 9d27d9d2181838f76dee150882bdc58c # Masters of Cinema
                      - 957d0f44b592285f26449575e8b1167e # Special Edition
                      - eecf3a857724171f968a66cb5719e152 # IMAX
                      - 9f6cbff8cfe4ebbc1bde14c7b7bec0de # IMAX Enhanced
                      # HQ Release Groups
                      - ed27ebfef2f323e964fb1f61391bcb35 # HD Bluray Tier 01
                      - c20c8647f2746a1f4c4262b0fbbeeeae # HD Bluray Tier 02
                      - c20f169ef63c5f40c2def54abaf4438e # WEB Tier 01
                      - 403816d65392c79236dcb6dd591aeda4 # WEB Tier 02
                      - af94e0fe497124d1f9ce732069ec8c3b # WEB Tier 03
                      # Misc
                      - e7718d7a3ce595f289bfee26adc178f5 # Repack/Proper
                      - ae43b294509409a6a13919dedd4764c4 # Repack2
                      # Unwanted
                      - ed38b889b31be83fda192888e2286d83 # BR-DISK
                      - 90a6f9a284dff5103f6346090e6280c8 # LQ
                      - dc98083864ea246d05a42df0d05f81cc # x265
                      - b8cd450cbfa689c0259a01d9e29ba3d6 # 3D
                      # Streaming Services
                      - b3b3a6ac74ecbd56bcdbefa4799fb9df # AMZN
                      - 40e9380490e748672c2522eaaeb692f7 # ATVP
                      - cc5e51a9e85a6296ceefe097a77f12f4 # BCORE
                      - 84272245b2988854bfb76a16e60baea5 # DNSP
                      - 509e5f41146e278f9eab1ddaceb34515 # DBO
                      - 5763d1b0ce84aff3b21038eea8e9b8ad # HMAX
                      - 526d445d4c16214309f0fd2b3be18a89 # Hulu
                      - 2a6039655313bf5dab1e43523b62c374 # MA
                      - 170b1d363bd8516fbf3a3eb05d4faff6 # NF
                      - bf7e73dd1d85b12cc527dc619761c840 # Pathe
                      - c9fd353f8f5f1baf56dc601c4cb29920 # PCOK
                      - e36a0ba1bc902b26ee40818a1d59b8bd # PMTP
                      - c2863d2a50c9acad1fb50e53ece60817 # STAN
                    quality_profiles:
                      - name: TRaSH 720/1080
          ''}:/config/recyclarr.yml"
        ];
        environmentFiles = [
          config.sops.secrets.serverenv.path
        ];
        environment = {
          PUID = toString config.users.users."media".uid;
          PGID = toString config.users.groups."media".gid;
        };
        extraOptions = [
          "--network=host"
        ];
      };

      prowlarr = {
        image = "lscr.io/linuxserver/prowlarr:latest";
        volumes = [
          "/media/config/prowlarr:/config"
        ];
        environment = {
          PUID = toString config.users.users."media".uid;
          PGID = toString config.users.groups."media".gid;
        };
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };

      sonarr = {
        image = "lscr.io/linuxserver/sonarr:latest";
        volumes = [
          "/media/config/sonarr:/config"
          "/media/library/tvseries:/tv"
          "/media/downloads:/downloads"
        ];
        environment = {
          PUID = toString config.users.users."media".uid;
          PGID = toString config.users.groups."media".gid;
        };
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };

      radarr = {
        image = "lscr.io/linuxserver/radarr:latest";
        volumes = [
          "/media/config/radarr:/config"
          "/media/library/movies:/movies"
          "/media/downloads:/downloads"
        ];
        environment = {
          PUID = toString config.users.users."media".uid;
          PGID = toString config.users.groups."media".gid;
        };
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };

      flaresolverr = {
        image = "flaresolverr/flaresolverr";
        environment = {
          LOG_LEVEL = "info";
        };
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };

      transmission = {
        image = "linuxserver/transmission:latest";
        volumes = [
          "/media/downloads:/downloads"
          "/media/config/transmission/config:/config"
          "/media/config/transmission/watch:/watch"
        ];
        environment = {
          PUID = toString config.users.users."media".uid;
          PGID = toString config.users.groups."media".gid;
          PEERPORT = "11936";
          USER = "xun";
          PASS = "password123";
        };
        dependsOn = ["gluetun"];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
    };
  };
}
