{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.xun.develop;
in {
  options.xun.develop = let
    enableOption = name: default: lib.mkEnableOption name // {inherit default;};
  in {
    enable = enableOption "develop" false;
    git.enable = enableOption "git" true;
    nix.enable = enableOption "nix" true;
    tools.enable = enableOption "tools" true;
    docs.enable = enableOption "man caches" false;
    lsp.c.enable = enableOption "clangd" false;
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.nix.enable {
        home.packages = with pkgs; [nil alejandra];
      })
      (lib.mkIf cfg.tools.enable {
        home.packages = with pkgs; [tokei];
      })
      (lib.mkIf cfg.git.enable {
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
      (lib.mkIf cfg.lsp.c.enable {
        home.packages = with pkgs; [clang-tools];
      })
      (lib.mkIf cfg.docs.enable {
        programs.man.generateCaches = true;
      })
    ]
  );
}
