{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.xun.develop;
in {
  options.xun.develop = let
    enableOption = default:
      lib.mkOption {
        inherit default;
        type = lib.types.bool;
      };
  in {
    enable = enableOption false;
    git.enable = enableOption true;
    nix.enable = enableOption true;
    tools.enable = enableOption true;
    docs.enable = enableOption false;
    devenv.enable = enableOption true;
    lang = {
      c.enable = enableOption false;
      csharp.enable = enableOption false;
      shell.enable = enableOption false;
      zig.enable = enableOption false;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.nix.enable {
        home.packages = with pkgs; [nil nixd alejandra nixfmt-rfc-style];
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
        home.packages = with pkgs; [clang-tools buckle];
      })
      (lib.mkIf cfg.lang.csharp.enable {
        home.packages = with pkgs; [
          csharpier
          omnisharp-roslyn
          roslyn-ls
        ];
      })
      (lib.mkIf cfg.lang.shell.enable {
        home.packages = with pkgs; [
          shellcheck
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
