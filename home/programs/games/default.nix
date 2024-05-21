{
  pkgs,
  self,
  ...
}: {
  home.packages = with pkgs; [
    heroic
    lutris
    prismlauncher
    self.packages.${pkgs.system}.gamesand
  ];
  programs.mangohud.enable = true;
}
