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
    config =
      if cfg.enable
      then
        (cfg
          // {
            enable = true;
            nix.enable = true;
            tools.enable = true;
            docs.enable = true;
            lsp.c.enable = true;
          })
      else cfg;
  in
    lib.mkMerge [
      (lib.mkIf config.nix.enable {
        home.packages = with pkgs; [nil alejandra];
      })
      (lib.mkIf config.tools.enable {
        home.packages = with pkgs; [tokei];
      })
      (lib.mkIf config.lsp.c.enable {
        home.packages = with pkgs; [clang-tools];
      })
      (lib.mkIf config.docs.enable {
        programs.man.generateCaches = true;
      })
    ];
}
