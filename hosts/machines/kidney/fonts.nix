{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      font-awesome
      iosevka
      emacs-all-the-icons-fonts
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
    enableDefaultPackages = false;
    fontconfig.defaultFonts = {
      monospace = ["Iosevka"];
    };
  };
}
