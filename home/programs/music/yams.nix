{pkgs, ...}: {
  # authentication needs to be done manually once
  # TODO automatic authentication thing
  home.packages = with pkgs; [yams];
  systemd.user.services.yams = {
    Unit = {
      Description = "yams";
      Requires = ["mpd.service"];
      After = ["mpd.service"];
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      Type = "simple";
      Environment = "NON_INTERACTIVE=1";
      ExecStart = "${pkgs.yams}/bin/yams -N";
    };
  };
}
