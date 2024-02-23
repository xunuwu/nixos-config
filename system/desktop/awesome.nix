{
  imports = [
    ./x11
  ];
  services.xserver = {
    enable = true;
    windowManager.awesome.enable = true;
  };
}
