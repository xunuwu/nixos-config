{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk; # uses xwayland, use pgtk for native wayland or pkgs.emacs if using daemon
    extraPackages = e: [e.vterm];
  };
}
