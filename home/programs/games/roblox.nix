{
  self,
  pkgs,
  ...
}: {
  # i have sober installed imperatively through flatpak
  home.packages = [
    self.packages.${pkgs.system}.sobercookie
  ];
}
