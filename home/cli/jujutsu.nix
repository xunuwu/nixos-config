{config, ...}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = config.programs.git.settings.user.email;
        name = config.programs.git.settings.user.name;
      };
      signing = {
        behavior = "own";
        backend = "ssh";
        key = config.programs.git.signing.key;
      };
    };
  };
}
