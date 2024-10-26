{self, ...}: {
  imports = [
    self.nixosModules.xun
  ];
  xun.gaming = let
    enabled = {enable = true;};
  in {
    enable = true;
    steam = enabled;
    gamescope = enabled;
    gamemode = enabled;
    sunshine = {
      enable = true;
      openFirewall = true;
    };
  };
}
