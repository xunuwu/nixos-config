{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    wl-clipboard
  ];

  services.cliphist = {
    enable = true;
    systemdTarget = "hyprland-session.target";
  };
  #systemd.user.services.cliphist = {
  #  Unit = {
  #    Description = "Wayland clipboard manager";
  #    PartOf = ["hyprland-session.target"];
  #    After = ["hyprland-session.target"];
  #  };

  #  Service = {
  #    ExecStartPre = "${pkgs.wl-clipboard}/wl-paste --type text --watch ${lib.getExe pkgs.cliphist} store #Stores only text data";
  #    ExecStart = "${pkgs.wl-clipboard}/wl-paste --type image --watch ${lib.getExe pkgs.cliphist} store #Stores only image data";
  #    ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
  #    Restart = "on-failure";
  #  };

  #  Install = {
  #    WantedBy = ["hyprland-session.target"];
  #  };
  #};
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${lib.getExe pkgs.foot}";
        layer = "overlay";
      };
      colors = {
        background = "#181818ff";
        text = "#a4c6d9ff";
        match = "#ae61b5ff";
        border = "#feafffff";
        selection = "#242424ff";
        selection-text = "#ffffffff";
        selection-match = "#fac1ffff";
      };
    };
  };

  programs.waybar = {
    enable = true;
    style = ''
      * {
        font-family: monospace;
        font-size: 13px;
      }

      window#waybar {
          background-color: #181818;
          color: #ffffff;
          transition-property: background-color;
          transition-duration: .5s;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      button {
          /* Avoid rounded borders under each button name */
          border: none;
          border-radius: 0;
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      button:hover {
          background: inherit;
      }

      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #ffffff;
      }

      #workspaces button:hover {
          background: rgba(255, 255, 255, 0.1);
      }

      #workspaces button.focused {
          background-color: #64727D;
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
      }

      #workspaces button.visible {
        color: #fd4dff;
        background-color: #202020;
      }

      #clock,
      #network,
      #pulseaudio,
      #wireplumber,
      #tray {
          padding: 0 10px;
          color: #ffffff;
      }

      #window,
      #workspaces {
          margin: 0 4px;
      }
      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }
      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #000000;
          }
      }
      label:focus {
          background-color: #000000;
      }
      #tray {
          background-color: #242424;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
      }

    '';
    settings = [
      {
        "height" = 24;
        "spacing" = 4;
        "modules-left" = [
          "hyprland/workspaces"
          #"hyprland/mode"
          #"hyprland/scratchpad"
        ];
        "modules-center" = [
          "hyprland/window"
        ];
        "modules-right" = [
          "pulseaudio"
          "clock"
          "tray"
        ];

        "hyprland/workspaces" = {
          "format" = "[{icon} {windows}]";
          "format-window-separator" = ",";
          "window-rewrite-default" = "@";
          "window-rewrite" = {
            "title<.*discord.*>" = "d";
            "class<Sonixd>" = "m";
            "class<firefox>" = "f";
            "foot" = "t";
          };
        };

        "tray" = {
          "spacing" = 10;
        };
        "clock" = {
          "tooltim-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };
        "pulseaudio" = {
          "format" = "{volume}%";
          "format-source" = "{volume}%";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" ""];
          };
          "on-click" = "${lib.getExe pkgs.pavucontrol}";
          "on-click-middle" = "${lib.getExe pkgs.helvum}";
        };
      }
    ];
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        #"${lib.getExe pkgs.xwaylandvideobridge}"
        "${lib.getExe pkgs.swaybg} -i ${config.xdg.userDirs.pictures}/wallpaper.png"
      ];
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

      input = {
        kb_layout = "eu";
      };

      general = {
        gaps_out = 3;
        gaps_in = 3;
        "col.active_border" = "rgb(feafff) rgb(fd56ff)";
      };

      dwindle = {
        preserve_split = true;
      };

      workspace = [
        "1,monitor:DP-3"
        "2,monitor:DP-3"
        "3,monitor:DP-3"
        "4,monitor:DP-3"
        "5,monitor:DP-3"

        "11,defaultName:q,monitor:HDMI-A-1"
        "12,defaultName:w,monitor:HDMI-A-1"
        "13,defaultName:e,monitor:HDMI-A-1"
        "14,defaultName:r,monitor:HDMI-A-1"
        "15,defaultName:t,monitor:HDMI-A-1"
      ];

      animation = [
        "workspaces,1,3,default"
        "windows,1,3,default"
        "border,1,3,default"
      ];

      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, RETURN, exec, ${lib.getExe pkgs.foot}"
        "$mainMod, G, killactive"
        "$mainMod, SPACE, togglefloating"
        "$mainMod, F, fullscreen"
        "$mainMod, M, fullscreen, 1"
        "$mainMod SHIFT, F, fakefullscreen"
        "$mainMod, P, exec, ${lib.getExe pkgs.fuzzel}"
        "$mainMod SHIFT, V, exec, ${lib.getExe pkgs.cliphist} list | ${lib.getExe pkgs.wofi} --dmenu | ${lib.getExe pkgs.cliphist} decode | ${pkgs.wl-clipboard}/bin/wl-copy"
        "$mainMod SHIFT, S, exec, ${lib.getExe pkgs.grimblast} --freeze copy area"

        "$mainMod, N, togglesplit"
        "$mainMod SHIFT, N, swapsplit"
        # preselect with mirrored vim keys, shifted down
        "$mainMod, B, layoutmsg, preselect r"
        "$mainMod, V, layoutmsg, preselect d"
        "$mainMod, C, layoutmsg, preselect u"
        "$mainMod, X, layoutmsg, preselect l"

        "$mainMod SHIFT, O, exec, ${lib.getExe pkgs.wlogout}"
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

        "$mainMod, q, workspace, 11"
        "$mainMod, w, workspace, 12"
        "$mainMod, e, workspace, 13"
        "$mainMod, r, workspace, 14"
        "$mainMod, t, workspace, 15"

        # move window to workspace with mod+shift+[0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"

        "$mainMod SHIFT, q, movetoworkspace, 11"
        "$mainMod SHIFT, w, movetoworkspace, 12"
        "$mainMod SHIFT, e, movetoworkspace, 13"
        "$mainMod SHIFT, r, movetoworkspace, 14"
        "$mainMod SHIFT, t, movetoworkspace, 15"

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

        "noanim,title:^(XtMapper)$"
        "noblur,title:^(XtMapper)$"
        "float,title:^(XtMapper)$"
        "move 0 0,title:^(XtMapper)$"
        "size 100%,title:^(XtMapper)$"
      ];
    };
  };
}
