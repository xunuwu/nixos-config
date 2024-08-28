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
    roblox.sobercookie.enable = lib.mkEnableOption "sobercookie";
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.krunker.enable {
      home.packages = [
        self.packages.${pkgs.system}.krunker
      ];
    })
    (lib.mkIf cfg.roblox.sobercookie.enable {
      home.packages = [
        self.packages.${pkgs.system}.sobercookie
      ];
    })
  ];
}
