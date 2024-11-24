_: {
  pkgs,
  self,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-black.yaml";
    image = pkgs.fetchurl {
      url = "https://i.imgur.com/j9xld8Y.png";
      hash = "sha256-ou7+S4QFC7Gabbwv9PKcQLLT/1J26FJM7qRVbjLUoRU=";
    };
    polarity = "dark";
    cursor = {
      package = pkgs.whitesur-cursors;
      name = "whitesur-cursors";
      size = 16;
    };
    fonts = {
      sizes = {
        terminal = 9;
        applications = 10;
      };
    };
  };

  fonts.packages = [
    self.packages.${pkgs.system}.cartograph-cf
  ];
}
