{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  users.users.desktop = {
    isNormalUser = true;
    useDefaultShell = true;
    createHome = true;
    extraGroups = [
      "input"
      "video"
      "render"
      "audio"
    ];
  };

  environment.systemPackages = with pkgs; [
    firefox
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = lib.getExe config.programs.sway.package;
        user = "desktop";
      };
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = ["--unsupported-gpu"];
  };
}
