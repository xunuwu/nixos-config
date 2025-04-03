{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (final: prev: {
      patches = [./waybar-workspace.patch];
    });
    settings = [
      {
        height = 24;
        spacing = 4;
        position = "top";
        modules-left = [
          "sway/workspaces"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          "mpris"
          "tray"
          "clock"
        ];
        "sway/workspaces" = {
          format = "{icon}";
        };
        "sway/window" = {
          max-length = 80;
        };
        mpris = {
          ignored-players = ["firefox"];
          on-click-right = "";
          on-click-middle = "";
          format = "{dynamic}";
          dynamic-order = ["title" "album" "artist"];
          dynamic-importance-order = ["title" "album" "artist"];
        };
        clock = {
          format = "{:%V|%d %a %H:%M}";
          tooltip-format = "<big>{:%a %Y-%m-%d %H:%M}</big>\n<small>{calendar}</small>";
        };
      }
    ];
    style = ''
      * {
          font-size: 13px;
      }

      button {
          border: none;
          border-radius: 0;
      }

      #workspaces button {
        padding: 0 5px;
      }

      #workspaces button.urgent {
        box-shadow: inset 0 -3px blue;
      }

      #clock {
        padding: 0 10px;
      }
    '';
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
  };
}
