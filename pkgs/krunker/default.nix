{
  appimageTools,
  imagemagick,
  nv_generated,
}: let
  inherit (nv_generated.krunker) pname src version;
  appimageContents = appimageTools.extract {
    inherit pname src version;
  };
in
  appimageTools.wrapType2 (nv_generated.krunker
    // {
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
    })
