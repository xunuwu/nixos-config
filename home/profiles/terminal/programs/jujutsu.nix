{config, ...}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = config.programs.git.userEmail;
        name = config.programs.git.userName;
      };
      signing = {
        behaviour = "own";
        backend = "ssh";
        key = config.programs.git.signing.key;
      };
    };
  };
}
