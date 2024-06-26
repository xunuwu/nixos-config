{lib, ...}: {
  imports = [
    ./security.nix
    ./users.nix
    ./ssh.nix
    ../nix
    ../programs/zsh.nix
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
    ];
  };
  services.xserver.xkb.layout = "eu";

  time.timeZone = lib.mkDefault "Europe/Berlin";
}
