{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk; # uses xwayland, use pgtk for native wayland or pkgs.emacs if using daemon
  };
}
