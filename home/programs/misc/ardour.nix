{pkgs, ...}: {
  home.packages = with pkgs; [
    ardour
    lsp-plugins
    sunvox
  ];
}
