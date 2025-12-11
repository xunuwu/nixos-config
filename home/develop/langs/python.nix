{pkgs, ...}: {
  home.packages = with pkgs; [
    basedpyright
  ];
}
