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
      url = "https://i.imgur.com/j9xld8Y.png";
      hash = "sha256-ou7+S4QFC7Gabbwv9PKcQLLT/1J26FJM7qRVbjLUoRU=";
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
