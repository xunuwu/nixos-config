{
  self,
  super,
  root,
}: {pkgs, ...}: {
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
      (stdenv.mkDerivation {
        # font piracy? i would never
        pname = "Cartograph-CF";
        version = "0.1";
        src = pkgs.fetchFromGitHub {
          owner = "xiyaowong";
          repo = "Cartograph-CF";
          rev = "619de85c103dbd5c150e1d5df039357f8ac2ed52";
          hash = "sha256-NVqHxLQZnHb0lMjODkaDwSoglGPkUVJHL1xTmASoER4=";
        };
        dontBuild = true;
        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/fonts
          cp -r $src $out/share/fonts

          runHook postInstall
        '';
      })
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
