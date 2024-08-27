{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.xun.develop;
in {
  options.xun.develop = {
    enable = lib.mkEnableOption "develop";
    nix.enable = lib.mkEnableOption "nix";
    tools.enable = lib.mkEnableOption "tools";
    docs.enable = lib.mkEnableOption "man caches";
    lsp.c.enable = lib.mkEnableOption "clangd";
  };

  config = let
    conf =
      if cfg.enable
      then
        (cfg
          // {
            nix.enable = true;
            tools.enable = true;
            docs.enable = true;
            lsp.c.enable = true;
          })
      else cfg;
  in
    lib.mkMerge [
      (lib.mkIf conf.nix.enable {
        home.packages = with pkgs; [nil alejandra];
      })
      (lib.mkIf conf.tools.enable {
        home.packages = with pkgs; [tokei];
      })
      (lib.mkIf conf.lsp.c.enable {
        home.packages = with pkgs; [clang-tools];
      })
      (lib.mkIf conf.docs.enable {
        programs.man.generateCaches = true;
      })
    ];
}
