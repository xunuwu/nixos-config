{
  self,
  super,
  root,
}: {
  imports = with super; [
    fonts
    home-manager
    qt
    adb
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;
  };
}
