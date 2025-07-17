{
  lib,
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  requireFile,
  unzip,
  libGL,
  glib,
  fontconfig,
  qt6,
  dbus,
  libxml2,
  python3,
  wayland,
  makeDesktopItem,
  imagemagick,
  wrapQtAppsHook,
}: let
  desktopItem = makeDesktopItem {
    name = "binaryninja-personal";
    exec = "binaryninja-personal";
    icon = "binaryninja";
    desktopName = "Binary Ninja Personal";
    genericName = "Binary Ninja Personal";
    categories = ["Development" "Debugger" "Profiling"];
    terminal = false;
  };
  crack = requireFile {
    name = "libbinaryninjacore.so.1";
    sha256 = "5d03d63e226cf7295270c003651c690766915cad5bbc42c4830d80517e3f005e";
    message = "add cracked libbinaryninjacore.so.1 to the nix store with command \"nix-store --add-fixed sha256 libbinaryninjacore.so.1\"";
  };
in
  stdenv.mkDerivation {
    name = "binaryninja-personal";

    nativeBuildInputs = [
      imagemagick
      wrapQtAppsHook
    ];

    buildInputs = [
      autoPatchelfHook
      makeWrapper
      unzip
      wayland
      libGL
      qt6.full
      qt6.qtbase
      stdenv.cc.cc.lib
      glib
      fontconfig
      dbus
    ];
    runtimeDependencies = [
      python3
    ];

    preFixup = ''
      mkdir -p $out/lib
      ln -s ${lib.getLib libxml2}/lib/libxml2.so $out/lib/libxml2.so.2
    '';

    src = requireFile {
      name = "binaryninja_personal_linux.zip";
      url = "https://binary.ninja/recover/";
      sha256 = "073d5dc59e67dabb8aa8c419385b2a0dc17831f108d73def4934e4cade563c87";
    };

    dontWrapQtApps = true;
    buildPhase = ":";
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mkdir -p $out/opt

      cp -r * $out/opt
      chmod +x $out/opt/binaryninja

      makeWrapper $out/opt/binaryninja \
            $out/bin/binaryninja-personal \
            --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [python3]} \
            "''${qtWrapperArgs[@]}"

      runHook postInstall
    '';

    postInstall = ''
      mkdir -p $out/share/applications
      ln -s ${desktopItem}/share/applications/* $out/share/applications

      for i in 16 24 48 64 96 128 256 512; do
        mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
        convert -background none -resize ''${i}x''${i} $out/opt/docs/img/logo.png $out/share/icons/hicolor/''${i}x''${i}/apps/binaryninja.png
      done

      cp -r ${crack} $out/opt/binja-crack.so
      patchelf --replace-needed libbinaryninjacore.so.1 $out/opt/binja-crack.so $out/opt/binaryninja
    '';
  }
