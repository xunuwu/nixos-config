{lib, ...}: {
  imports = [
    ./security.nix
    ./users.nix
    ./tools.nix
    ./ssh.nix
    ../nix
    ../programs/zsh.nix
  ];

  documentation.dev.enable = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
    ];
  };
  services.xserver.layout = "eu";

  # don't touch this
  system.stateVersion = lib.mkDefault "23.11";

  time.timeZone = lib.mkDefault "Europe/Stockholm";
}
