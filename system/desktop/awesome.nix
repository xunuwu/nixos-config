{
  imports = [
    ./x11.nix
  ];
  services.xserver = {
    enable = true;
    windowManager.awesome.enable = true;
  };
}
