{
  pkgs,
  config,
  lib,
  inputs,
  self,
  ...
}: let
  cfg = config.xun.gaming;
in {
  options.xun.gaming = {
    krunker.enable = lib.mkEnableOption "krunker";
    roblox.sobercookie.enable = lib.mkEnableOption "sobercookie";
    umu.enable = lib.mkEnableOption "umu-launcher";
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.umu.enable {
      home.packages = [inputs.umu.packages.${pkgs.system}.umu];
    })
    (lib.mkIf cfg.krunker.enable {
      home.packages = [
        self.packages.${pkgs.system}.krunker
      ];
    })
    (lib.mkIf cfg.roblox.sobercookie.enable {
      home.packages = [
        inputs.sobercookie.packages.${pkgs.system}.default
      ];
    })
  ];
}
