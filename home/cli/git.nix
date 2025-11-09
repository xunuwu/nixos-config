{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    git-credential-oauth
  ];

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    ignores = ["*~" ".direnv"];

    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519";
      signByDefault = true;
    };

    settings = {
      gpg.format = "ssh";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autostash = true;
      user = {
        name = "xunuwu";
        email = "xunuwu@gmail.com";
      };
    };
  };
}
