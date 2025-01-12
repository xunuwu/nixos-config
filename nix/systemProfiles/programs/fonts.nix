{
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

      nerd-fonts.symbols-only
      nerd-fonts.sauce-code-pro
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka-term
      nerd-fonts.iosevka
      nerd-fonts.inconsolata
      nerd-fonts.fira-code
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.blex-mono
      nerd-fonts._0xproto

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
