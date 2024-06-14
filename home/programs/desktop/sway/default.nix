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
      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
        wobVolume = "${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_SINK@ | awk '{print $2*100}' > $XDG_RUNTIME_DIR/wob.sock";
        setVolume = limit: amount: "${pkgs.wireplumber}/bin/wpctl set-volume -l ${limit} @DEFAULT_AUDIO_SINK@ ${amount}";
        perMonitor = workspace: "\"$(swaymsg -t get_outputs | ${lib.getExe pkgs.jq} -r '.[] | select(.focused == true).name' | ${lib.getExe pkgs.perl} -ne '$s=0;for(split//){$s+=ord}print\"$s\"')${toString workspace}\"";
        #perMonitor = workspace: "${lib.getExe (pkgs.writeShellScriptBin "perMonitor" ''
        #  id=$( md5sum <<< ${config.wayland.windowManager.sway.package}/bin/swaymsg -t get_outputs | ${lib.getExe pkgs.jq} -r '.[] | select(.focused == true).id' )
        #  echo $((0x''${id%% *}))
        #'')} workspace";
        #perMonitor = pkgs.writeShellScriptBin "perMonitor" ''
        #  args=( "$@" )
        #  id=$( ${config.wayland.windowManager.sway.package}/bin/swaymsg -t get_outputs | ${lib.getExe pkgs.jq} -r '.[] | select(.focused == true).id' )
        #  # args[$#-1]=$(( ''${args[$#-1]} + $id * 10 ))
        #  args[$#-1]="$id:''${args[$#-1]}"
        #  swaymsg ''${args[@]}
        #'';
        dir = with config.wayland.windowManager.sway.config; {
          inherit up down left right;
        };
      in
        lib.mkOptionDefault (
          {
            "${mod}+Shift+v" = "exec ${lib.getExe pkgs.cliphist} list | ${lib.getExe pkgs.wofi} --dmenu | ${lib.getExe pkgs.cliphist} decode | ${pkgs.wl-clipboard}/bin/wl-copy";
            "${mod}+Ctrl+${dir.left}" = "focus output left";
            "${mod}+Ctrl+${dir.right}" = "focus output right";
            "${mod}+Ctrl+${dir.up}" = "focus output up";
            "${mod}+Ctrl+${dir.down}" = "focus output down";

            "${mod}+Ctrl+Shift+${dir.left}" = "move output left";
            "${mod}+Ctrl+Shift+${dir.right}" = "move output right";
            "${mod}+Ctrl+Shift+${dir.up}" = "move output up";
            "${mod}+Ctrl+Shift+${dir.down}" = "move output down";

            "${mod}+d" = "exec ${lib.getExe pkgs.fuzzel}";
            "${mod}+Shift+Backspace" = "exec systemctl suspend";
            "${mod}+Shift+s" = "exec ${lib.getExe pkgs.grimblast} copy area";

            "XF86AudioRaiseVolume" = "exec ${setVolume "1.5" "3%+"} && ${wobVolume}";
            "XF86AudioLowerVolume" = "exec ${setVolume "1.5" "3%-"} && ${wobVolume}";
            "XF86AudioPlay" = "exec ${lib.getExe pkgs.playerctl} play-pause";
            "XF86AudioStop" = "exec ${lib.getExe pkgs.playerctl} stop";
            "XF86AudioNext" = "exec ${lib.getExe pkgs.playerctl} next";
            "XF86AudioPrev" = "exec ${lib.getExe pkgs.playerctl} previous";
          }
          // builtins.listToAttrs (lib.flatten
            (builtins.map (x: [
              {
                name = "${mod}+${toString x}";
                value = "exec swaymsg workspace number ${perMonitor x}:${toString x}";
              }
              {
                name = "${mod}+Shift+${toString x}";
                value = "exec swaymsg move container to workspace number ${perMonitor x}:${toString x}";
              }
            ]) (lib.range 0 9)))
        );
    };
  };
}
