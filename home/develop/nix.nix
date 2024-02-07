{pkgs, ...}: {
  home.packages = with pkgs; [
    nil
    alejandra
  ];
}
