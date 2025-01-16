{
  pkgs,
  self,
  ...
}: {
  home.packages = [self.packages.${pkgs.system}.gamesand];
  programs.mangohud.enable = true;
}
