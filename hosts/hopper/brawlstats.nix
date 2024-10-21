{
  pkgs,
  lib,
  config,
  ...
}: {
  networking.firewall.allowedTCPPorts = [
    # 4444
  ];

  systemd.services."static-web-server".after = ["brawlstats.timer"];

  services.static-web-server = {
    enable = true;
    root = "/var/lib/brawlstats";
    listen = "[::]:3434";
  };

  systemd.sockets."brawlstats-web" = {
    wantedBy = ["sockets.target"];

    socketConfig = {
      ListenStream = "4444";
      TriggerLimitIntervalSec = 0;
      Accept = "yes";
    };
  };

  systemd.services."brawlstats-web@" = {
    serviceConfig = {
      StandardInput = "socket";
      ExecStart = "${pkgs.writeShellScript "brawlstats-web.sh" ''
        parameters=$(head -n1 | ${lib.getExe pkgs.gawk} '{print $2}' | ${lib.getExe pkgs.gnused} 's/,/ /g')
        response=""

        tosvg() {
          ${lib.getExe pkgs.gnuplot} -c ${pkgs.writeText "gnuplotcmds" ''
          set xdata time
          set timefmt '%Y%m%dT%H%M%S.000Z'
          set format x '%m/%d-%H:%M'
          set xlabel 'Time'
          set ylabel 'Trophies'
          set term svg
          plot "/dev/stdin" u 1:2 w lines notitle
        ''}
        }

        rm /tmp/brawlstatslog

        case ''${parameters:1} in
          total*)
            id=$(echo $parameters | ${lib.getExe pkgs.gawk} '{print $2}')
            trophies=$(cat "/var/lib/brawlstats/$id-player.json" | ${lib.getExe pkgs.jq} '.trophies')
            response=$(${lib.getExe pkgs.jq} -r \
              "sort_by(.battleTime)
              | reverse | .[]
              | .battleTime, .battle.trophyChange" "/var/lib/brawlstats/$id-log.json" \
                | paste - - \
                | ${lib.getExe pkgs.gawk} -v total=$trophies '{total -= $2; $2 = total}2' \
                | tosvg)
            ;;
          brawler*)
            id=$(echo $parameters | ${lib.getExe pkgs.gawk} '{print $2}')
            brawler=$(echo $parameters | ${lib.getExe pkgs.gawk} '{print $3}' | ${lib.getExe pkgs.gnused} 's/%20/ /g')
            response=$(${lib.getExe pkgs.jq} -r \
              "sort_by(.battleTime)
              | reverse
              | map (select (.. | .tag? == \"#$id\" and .brawler.name == \"$brawler\")).[]
              | select (.battle.type == \"ranked\")
              | .battleTime,
              (.battle | (.teams[]?,.players) | select(.)[] | select(.tag == \"#$id\") | .brawler.trophies) + .battle.trophyChange" "/var/lib/brawlstats/$id-log.json" \
              | paste - - \
              | tosvg)
           ;;
          *)
            response="parameters: $parameters | firstparam: $(echo "$parameters" | ${lib.getExe pkgs.gawk} '{print $1}')"
            ;;
        esac

        echo -e "HTTP/1.1 200 OK\r\nContent-Length: $(echo "$response" | wc -c)\r\nContent-Type: text/html\r\n\r\n$response"
      ''}";
    };
  };

  systemd.timers."brawlstats" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*:0/30";
      Unit = "brawlstats.service";
    };
  };

  systemd.services."brawlstats" = {
    serviceConfig = {
      Type = "oneshot";

      User = "root";

      StateDirectory = "brawlstats";

      PrivateTmp = true;

      LoadCredential = "apitoken:${config.sops.secrets.brawlstars-api-key.path}";
      Environment = "TOKEN=%d/apitoken";

      ExecStart = pkgs.writers.writeBash "brawlstats.sh" ''
        TOKEN=$(cat $TOKEN)

        cd "$STATE_DIRECTORY"

        ids=("VLJY22GY" "VLJV2CYL")

        for id in ''${ids[@]}; do
           echo "id: $id"

           sleep 1
           battlelogout=$(mktemp)
           ${lib.getExe pkgs.curl} -H "Authorization: Bearer $TOKEN" "https://api.brawlstars.com/v1/players/%23$id/battlelog" | ${lib.getExe pkgs.jq} '[.items[]]' > "$battlelogout"
           sleep 1
           ${lib.getExe pkgs.curl} -H "Authorization: Bearer $TOKEN" "https://api.brawlstars.com/v1/players/%23$id" > "$id-player.json"


           if [ ! -s "$battlelogout" ]; then
              echo "battlelogout is empty"
              rm "$battlelogout"
              continue
           fi

           if [ ! -s "$id-player.json" ]; then
              echo "$id-player.json is empty"
              continue
           fi

           tmplog=$(mktemp)
           cat "$battlelogout" "$id-log.json" | ${lib.getExe pkgs.jq} -s 'add | unique' > "$tmplog"
           cat "$tmplog" > "$id-log.json"

           rm -f "$tmplog"
           rm -f "$battlelogout"

           # create backup
           cp "$id-log.json" "$id-log-$(date +'%s').json"

           # remove old backups
           find . -type f -name "$id-log-*.json" | sort | head -n -5 | xargs -r rm
        done
      '';
    };
  };
}
