{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.xun.school;
in {
  options.xun.school = {
    geogebra.enable = lib.mkEnableOption "geogebra";
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.geogebra.enable {
      home.packages = with pkgs; [
        geogebra6
      ];
    })
  ];
}
