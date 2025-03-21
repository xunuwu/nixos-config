{
  pkgs,
  self,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/mountain.yaml";
    image = pkgs.fetchurl {
      url = "https://imgur.com/2HATcuP.png";
      hash = "sha256-YsSg1nreefSD/Ij44ZrWMkdk6+rJ2YozcFXvCM/EZNM=";
    };
    polarity = "dark";
    cursor = {
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 20;
    };
    fonts = {
      sizes = {
        terminal = 9;
        applications = 10;
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
    };
  };
}
