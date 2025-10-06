{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-gtk3;
    extraPackages = e: [
      e.vterm
      pkgs.texlive.combined.scheme-medium
      pkgs.sqlite
    ];
  };
}
