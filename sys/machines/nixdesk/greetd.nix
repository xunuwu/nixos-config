{
  config,
  lib,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = lib.getExe config.programs.sway.package;
        user = "xun";
      };
    };
  };
}
