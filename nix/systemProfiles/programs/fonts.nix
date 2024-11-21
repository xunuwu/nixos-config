_: {
  pkgs,
  self,
  ...
}: {
  fonts = {
    packages = with pkgs; [
      powerline-fonts
      dejavu_fonts
      font-awesome
      noto-fonts
      noto-fonts-emoji
      source-code-pro
      iosevka

      nerdfonts
      #(nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
      self.packages.${pkgs.system}.cartograph-cf
    ];

    # causes more issues than it solves
    enableDefaultPackages = false;

    # user defined fonts
    fontconfig.defaultFonts = {
      monospace = ["DejaVu Sans Mono for Powerline"];
      sansSerif = ["DejaVu Sans"];
    };
  };
}
