{pkgs, ...}: {
  ## TODO MAKE THIS REMOVE ALL PREV HEADLESS MONITORS
  home.packages = [
    (pkgs.writeShellApplication {
      name = "xun-start-headless";
      runtimeInputs = [pkgs.sway pkgs.wayvnc pkgs.jq];
      text = ''
        headless_numbers() {
          swaymsg -t get_outputs | jq -r '.[].name | select (. | startswith("HEADLESS-")) | ltrimstr("HEADLESS-")'
        }

        new_lines() {
          diff <(echo "$1") <(echo "$2") | grep -E "^>" | cut -c3- || true
        }

        create_output() {
          outputs1=$(headless_numbers)
          swaymsg create_output >/dev/null
          outputs2=$(headless_numbers)
          new_lines "$outputs1" "$outputs2"
        }

        remove_outputs() {
          for n in $(headless_numbers); do
            swaymsg output "HEADLESS-$n" unplug
          done
        }

        remove_outputs

        outputid=$(create_output)

        swaymsg output "HEADLESS-$outputid" scale 2
        swaymsg output "HEADLESS-$outputid" mode "2400x1080@30Hz"
        swaymsg output "HEADLESS-$outputid" position "0 1080" # below primary monitor

        wayvnc --gpu -o "HEADLESS-$outputid" 0.0.0.0
      '';
    })
  ];
}
