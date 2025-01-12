{
  inputs,
  pkgs,
  ...
}: {
  # i have sober installed imperatively through flatpak
  home.packages = [
    inputs.sobercookie.packages.${pkgs.system}.default
  ];
}
