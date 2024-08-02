{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}: {
  imports = [
    ../common/fuzzel.nix
    ../common/wob.nix
    ../common/wl-clipboard.nix
  ];

  services.cliphist = {
    enable = true;
    systemdTarget = "sway-session.target";
    extraOptions = ["-max-items" "150"];
  };

  # notification center
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false; # doesnt work with custom wallpaper
    config = {
      modifier = "Mod4";
      output = {
        "*".bg = "${config.xdg.userDirs.pictures}/wallpaper fill";
      };
      input = {
        "*".xkb_layout = osConfig.services.xserver.xkb.layout;
      };
      bars = [
        {
          workspaceNumbers = false;
          statusCommand = "${lib.getExe pkgs.i3status}";
        }
      ];
      window = {
        titlebar = false;
      };
      menu = "${lib.getExe pkgs.fuzzel}";
      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
        wobVolume = "${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_SINK@ | awk '{print $2*100}' > $XDG_RUNTIME_DIR/wob.sock";
        setVolume = limit: amount: "${pkgs.wireplumber}/bin/wpctl set-volume -l ${limit} @DEFAULT_AUDIO_SINK@ ${amount}";
        #perMonitor = workspace: "\"$(swaymsg -t get_outputs | ${lib.getExe pkgs.jq} -r '.[] | select(.focused == true).name' | ${lib.getExe pkgs.perl} -ne '$s=0;for(split//){$s+=ord}print\"$s\"')${toString workspace}\"";
        monitorId = pkgs.writers.writeBash "monitor-id" ''
          swaymsg -t get_outputs \
            | ${lib.getExe pkgs.jq} -r '.[] | select (.focused == true).name' \
            | ${lib.getExe pkgs.perl} -ne '$s=0;for(split//){$s+=ord}print"$s"'
        '';
        pauseApp = pkgs.writers.writeBash "pause-app" ''
          set -e
          pid=$(swaymsg -t get_tree \
            | ${lib.getExe pkgs.jq} -re '.. | select (.type? == "con" and .focused? == true).pid')

          if [ $(cat "/proc/$pid/wchan") == "do_signal_stop" ]; then
            kill -s SIGCONT $pid
          else
            kill -s SIGSTOP $pid
          fi
        '';
        dir = {
          inherit (config.wayland.windowManager.sway.config) up down left right;
        };
      in
        lib.mkOptionDefault (
          {
            "${mod}+n" = "exec ${pkgs.swaynotificationcenter}/bin/swaync-client -t";
            "${mod}+Shift+v" = "exec ${lib.getExe pkgs.cliphist} list | ${lib.getExe pkgs.wofi} --dmenu | ${lib.getExe pkgs.cliphist} decode | ${pkgs.wl-clipboard}/bin/wl-copy";
            "${mod}+Ctrl+${dir.left}" = "focus output left";
            "${mod}+Ctrl+${dir.right}" = "focus output right";
            "${mod}+Ctrl+${dir.up}" = "focus output up";
            "${mod}+Ctrl+${dir.down}" = "focus output down";

            "${mod}+Ctrl+Shift+${dir.left}" = "move output left";
            "${mod}+Ctrl+Shift+${dir.right}" = "move output right";
            "${mod}+Ctrl+Shift+${dir.up}" = "move output up";
            "${mod}+Ctrl+Shift+${dir.down}" = "move output down";

            "${mod}+Shift+Backspace" = "exec systemctl suspend";
            "${mod}+Shift+s" = "exec ${lib.getExe pkgs.sway-contrib.grimshot} copy anything";
            "${mod}+Ctrl+Shift+s" = "exec ${lib.getExe pkgs.sway-contrib.grimshot} savecopy anything";

            "${mod}+Shift+p" = "exec ${pauseApp}";

            "XF86AudioRaiseVolume" = "exec ${setVolume "1.5" "3%+"} && ${wobVolume}";
            "XF86AudioLowerVolume" = "exec ${setVolume "1.5" "3%-"} && ${wobVolume}";
            "XF86AudioPlay" = "exec ${lib.getExe pkgs.playerctl} play-pause";
            "XF86AudioStop" = "exec ${lib.getExe pkgs.playerctl} stop";
            "XF86AudioNext" = "exec ${lib.getExe pkgs.playerctl} next";
            "XF86AudioPrev" = "exec ${lib.getExe pkgs.playerctl} previous";
          }
          // (let
            inherit (builtins) foldl';
            inherit (lib) range;
          in
            foldl' (acc: x:
              acc
              // (let
                y = toString x;
              in {
                "${mod}+${y}" = "exec swaymsg workspace number \"$(${monitorId})${y}:${y}\"";
                "${mod}+Shift+${y}" = "exec swaymsg move container to workspace number \"$(${monitorId})${y}:${y}\"";
              }))
            {}
            (range 0 9))
        );
    };
  };
}
