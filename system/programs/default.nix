{
  imports = [
    ./fonts.nix
    ./home-manager.nix
    ./qt.nix
    ./adb.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;
  };
}
