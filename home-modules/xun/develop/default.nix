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
    devenv.enable = enableOption "devenv" true;
    lang = {
      c.enable = enableOption "clangd" false;
      csharp.enable = enableOption "csharp" false;
      zig.enable = enableOption "zig" false;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.nix.enable {
        home.packages = with pkgs; [nil nixd alejandra];
      })
      (lib.mkIf cfg.tools.enable {
        home.packages = with pkgs; [tokei];
      })
      (lib.mkIf cfg.devenv.enable {
        home.packages = with pkgs; [devenv];
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
            pull.rebase = true;
            rebase.autostash = true;
          };

          userEmail = "xunuwu@gmail.com";
          userName = "xunuwu";
        };
      })
      (lib.mkIf cfg.lang.c.enable {
        home.packages = with pkgs; [clang-tools];
      })
      (lib.mkIf cfg.lang.csharp.enable {
        home.packages = with pkgs; [
          csharpier
          omnisharp-roslyn
        ];
      })
      (lib.mkIf cfg.lang.zig.enable {
        home.packages = with pkgs; [zig zls];
      })
      (lib.mkIf cfg.docs.enable {
        programs.man.generateCaches = true;
      })
    ]
  );
}
