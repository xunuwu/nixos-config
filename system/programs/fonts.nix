{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      powerline-fonts
      dejavu_fonts
      font-awesome
      noto-fonts
      noto-fonts-emoji
      source-code-pro
      iosevka

      # nerdfonts
      nerdfonts
      #(nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];

    # causes more issues than it solves
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      monospace = ["DejaVu Sans Mono for Powerline"];
      sansSerif = ["DejaVu Sans"];
    };
  };
}
