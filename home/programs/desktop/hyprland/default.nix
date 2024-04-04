{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        "${lib.getExe pkgs.waybar}"
        "${lib.getExe pkgs.xwaylandvideobridge}"
        "${lib.getExe pkgs.swaybg} -i ${config.xdg.userDirs.pictures}/wallpaper.png"
      ];
      input = {
        kb_layout = "eu";
      };
      env = [
        "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
        "MOZ_WEBRENDER,1"
        # misc
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "GDK_BACKEND,wayland"
      ];

      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, RETURN, exec, ${lib.getExe pkgs.foot}"
        "$mainMod, Q, killactive"
        "$mainMod, SPACE, togglefloating"
        "$mainMod, F, fullscreen"
        "$mainMod, M, fullscreen, 1"
        "$mainMod SHIFT, F, fakefullscreen"
        "$mainMod, P, exec, ${pkgs.bemenu}/bin/bemenu-run"

        "$mainMod SHIFT, E, exec, ${lib.getExe pkgs.wlogout}"
        # focus with vim keys
        "$mainMod, h, movefocus, l"
        "$mainMod, j, movefocus, d"
        "$mainMod, k, movefocus, u"
        "$mainMod, l, movefocus, r"
        # window move with vim keys
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, j, movewindow, d"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, l, movewindow, r"

        # switch workspace with mod+[0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # move window to workspace with mod+shift+[0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # scroll through workspaces with mod+scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        ", XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"
        ", XF86AudioStop, exec, ${lib.getExe pkgs.playerctl} stop"
        ", XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
        ", XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"
      ];
      bindm = [
        # mod+lbm/rmb for move/resize
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3%-"
      ];
      windowrulev2 = [
        # Allow hiding xwaylandvideobridge window correctly
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"

        #"stayfocused,title:^(XtMapper)$"
        "noanim,title:^(XtMapper)$"
        "noblur,title:^(XtMapper)$"
        "float,title:^(XtMapper)$"
        "move 0% 0%,title:^(XtMapper)$"
        "size 100%,title:^(XtMapper)$"
      ];
    };
  };
}
