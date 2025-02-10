{pkgs, ...}: {
  home.packages = with pkgs; [
    vscodium
  ];
}
