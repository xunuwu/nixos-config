{
  pkgs,
  config,
  lib,
  self,
  ...
}: let
  cfg = config.xun.gaming;
in {
  options.xun.gaming = {
    krunker.enable = lib.mkEnableOption "krunker";
    roblox.sobercookie = lib.mkEnableOption "";
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.krunker.enable {
      home.packages = [
        self.packages.${pkgs.system}.krunker
      ];
    })
  ];
}
