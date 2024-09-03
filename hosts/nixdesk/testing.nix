{self, ...}: {
  imports = [
    self.nixosModules.xun
  ];
  xun.gaming = {
    enable = true;
    steam.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
  };
}
