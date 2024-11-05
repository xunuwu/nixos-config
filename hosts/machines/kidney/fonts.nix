{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      font-awesome
      iosevka
      emacs-all-the-icons-fonts
      self.packages.${pkgs.system}.cartograph-cf
    ];
    enableDefaultPackages = false;
    fontconfig.defaultFonts = {
      monospace = ["Iosevka"];
    };
  };
}
