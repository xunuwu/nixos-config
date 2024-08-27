{config, ...}: {
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
}
