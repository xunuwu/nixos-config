{
  inputs,
  lib,
  pkgs,
  ...
}: {
  home.packages = [inputs.wayland-appusage.packages.${pkgs.stdenv.hostPlatform.system}.appusage];

  systemd.user.services.appusage = {
    Unit = {
      Description = "Appusage daemon";
    };

    Install.WantedBy = ["sway-session.target"];

    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${inputs.wayland-appusage.packages.${pkgs.stdenv.hostPlatform.system}.appusage-daemon}/bin/appusage-daemon";
      RestartSec = "5s";
    };
  };
}
