{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = e: [
      e.vterm
      pkgs.texlive.combined.scheme-medium
      pkgs.sqlite
    ];
  };
}
