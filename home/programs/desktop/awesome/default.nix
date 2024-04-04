{pkgs, ...}: {
  services.picom = {
    enable = true;
    vSync = true;
  };

  xsession.windowManager.awesome = {
    enable = true;
    noArgb = true;
    luaModules = with pkgs; [
      luaPackages.fennel
    ];
  };
  xdg.configFile."awesome" = {
    source = ./config;
  };
}
