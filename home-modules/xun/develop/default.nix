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
    git.enable = lib.mkEnableOption "git";
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
            git.enable = true;
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
      (lib.mkIf conf.git.enable {
        home.packages = with pkgs; [lazygit];
        programs.gh.enable = true;
        programs.gh-dash.enable = true;

        programs.git = {
          enable = true;
          delta.enable = true;
          lfs.enable = true;

          ignores = ["*~" ".direnv"];

          signing = {
            key = "${config.home.homeDirectory}/.ssh/id_ed25519";
            signByDefault = true;
          };

          extraConfig = {
            gpg.format = "ssh";
            push.autoSetupRemote = true;
          };

          userEmail = "xunuwu@gmail.com";
          userName = "xunuwu";
        };
      })
      (lib.mkIf conf.lsp.c.enable {
        home.packages = with pkgs; [clang-tools];
      })
      (lib.mkIf conf.docs.enable {
        programs.man.generateCaches = true;
      })
    ];
}
