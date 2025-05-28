{
  appimageTools,
  imagemagick,
  fetchurl,
}: let
  pname = "krunker";
  version = "1626868370902057";
  src = fetchurl {
    url = "https://client2.krunker.io/setup.AppImage";
    sha256 = "sha256-yG8E3a6AaX0TBK23TlBBLmiCfqzS8FldTfl7As4Dcvo=";
  };
  appimageContents = appimageTools.extract {
    inherit pname src version;
  };
in
  appimageTools.wrapType2 {
    inherit pname src version;
    extraInstallCommands = ''
      for i in 16 24 48 64 96 128 256 512; do
        mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
        ${imagemagick}/bin/convert -background none -resize ''${i}x ${appimageContents}/io.krunker.desktop.png $out/share/icons/hicolor/''${i}x''${i}/apps/io.krunker.desktop.png
      done

      install -m 444 -D ${appimageContents}/io.krunker.desktop.desktop $out/share/applications/krunker.desktop
      substituteInPlace $out/share/applications/krunker.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}' \
        --replace 'Name=Official Krunker.io Client' 'Name=Krunker.io'
    '';
  }
