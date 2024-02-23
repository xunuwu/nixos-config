{
  pkgs,
  self,
  ...
}: {
  home.packages = with pkgs; [
    heroic
    lutris
    prismlauncher
    gamescope
  ];
  programs.mangohud.enable = true;
}
