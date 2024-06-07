{
  pkgs,
  lib,
  config,
  ...
}: {
  networking.firewall.allowedTCPPorts = [
    4444
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
          set format x '%H:%M'
          set xlabel 'Time'
          set ylabel 'Trophies'
          set term svg
          plot "/dev/stdin" using 1:2 with linespoints notitle
        ''} # 2>/dev/null
        }

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
            brawler=$(echo $parameters | ${lib.getExe pkgs.gawk} '{print $3}')
            response=$(${lib.getExe pkgs.jq} -r \
              "sort_by(.battleTime)
              | reverse
              | map (select (.. | .tag? == \"#$id\" and .brawler.name == \"$brawler\")).[]
              | .battleTime,
              (.battle | (.teams[]?,.players) | select(.)[] | select(.tag == \"#$id\") | .brawler.trophies) + .battle.trophyChange" "/var/lib/brawlstats/$id-log.json" \
              | paste - - \
              | tosvg)
            #reponse=$(${lib.getExe pkgs.jq} -r \
            #  "sort_by(.battleTime)
            #  | reverse
            #  | map (select (.. | .tag? == \"#$id\" and .brawler.name == \"$brawler\")).[]
            #  | .battleTime,
            #  (.battle | (.teams[]?,.players) | select(.)[] | select(.tag == \"#$id\") | .brawler.trophies) + .battle.trophyChange" \
            #    "/var/lib/brawlstats/$id-log.json" \
            #    | paste - - \
            #    | tosvg)
            #echo $response
           ;;
          *)
            response="parameters: $parameters | firstparam: $(echo "$parameters" | ${lib.getExe pkgs.gawk} '{print $1}')"
            ;;
        esac

        #file="/var/lib/brawlstats/output.svg"
        echo -e "HTTP/1.1 200 OK\r\nContent-Length: $(echo "$response" | wc -c)\r\nContent-Type: text/html\r\n\r\n$response"
        #echo $endpoint
        #cat "$file"
        #while read -r LINE
        #do
        #    echo "$LINE"
        #    [ -z "$LINE" ] && break
        #done

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

      ExecStart = "${pkgs.writeShellScript "brawlstats.sh" ''
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
      ''}";
    };
  };
}
