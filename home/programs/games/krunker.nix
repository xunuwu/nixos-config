{
  self,
  pkgs,
  ...
}: {
  home.packages = [
    self.packages.${pkgs.system}.krunker
  ];
}
