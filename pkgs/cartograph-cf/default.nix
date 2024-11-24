{
  stdenv,
  fetchFromGitHub,
}: (stdenv.mkDerivation {
  # font piracy? i would never
  # TODO: use pkgs.nerd-font-patcher
  pname = "Cartograph-CF";
  version = "0.1";
  src = fetchFromGitHub {
    owner = "xiyaowong";
    repo = "Cartograph-CF";
    rev = "619de85c103dbd5c150e1d5df039357f8ac2ed52";
    hash = "sha256-NVqHxLQZnHb0lMjODkaDwSoglGPkUVJHL1xTmASoER4=";
  };
  dontBuild = true;
  installPhase = ''
    runHook preInstall


    install -Dm644 $src/Nerd\ Font/*.ttf -t $out/share/fonts/truetype/NerdFonts
    install -Dm644 $src/*.otf -t $out/share/fonts/opentype
    # mkdir -p $out/share/fonts
    # cp -r $src/Nerd\ Font $out/share/fonts/truetype

    runHook postInstall
  '';
})
