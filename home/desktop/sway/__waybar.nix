{
  pkgs,
  lib,
  self,
  ...
}: {
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
          "custom/keyboard-state"
          "tray"
          "clock"
        ];
        "sway/workspaces" = {
          format = "{icon}";
        };
        "sway/window" = {
          max-length = 80;
        };
        "custom/keyboard-state" = {
          return-type = "json";
          exec = "${lib.getExe self.packages.${pkgs.system}.keyboard-state}";
          restart-interval = "60";
        };
        clock = {
          format = "{:%V|%d %a %H:%M}";
          tooltip-format = "<big>{:%a %Y-%m-%d %H:%M}</big>\n<small>{calendar}</small>";
        };
      }
    ];
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
  };
}
