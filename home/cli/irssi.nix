{pkgs, ...}: {
  programs.irssi = {
    enable = true;
    networks = {
      liberachat = {
        nick = "wheat";
        server = {
          address = "irc.libera.chat";
          port = 6697;
          autoConnect = true;
        };
        channels = {
          nixos.autoJoin = false;
        };
      };
    };
  };
  home.file.".irssi/default.theme".source = pkgs.fetchurl {
    url = "https://irssi-import.github.io/themes/h3rbz.theme";
    hash = "sha256-2nB+jvDXPgkMXTd6f305R2aBt/D4kbsIGbqcIllHADo=";
  };
}
