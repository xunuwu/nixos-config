{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  bash,
  makeWrapper,
  luajitPackages,
  gobject-introspection,
  gtk3,
  wrapGAppsHook,
  luajit,
}:
stdenv.mkDerivation rec {
  pname = "sobercookie";
  src = fetchFromGitHub {
    owner = "xunuwu";
    repo = "sobercookie";
    rev = "09b75ce925281a60a90281e9c5007720f50d48fb";
    sha256 = "sha256-FIGXxG9CCSq1MPPiC5nHVdKJMwpz1Apd00Ix53jtYwk=";
  };
  version = "0.0.1";

  buildInputs = [bash luajit];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    wrapGAppsHook
    gobject-introspection
  ];

  propagatedBuildInputs = [gtk3];
  lgi = luajitPackages.lgi;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp sobercookie $out/bin/sobercookie
    cp launcher.lua $out/bin/sobercookie-launcher

    mkdir -p $out/share/applications
    cp sobercookie-launcher.desktop $out/share/applications

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LUA_PATH : "./?.lua;${lgi}/share/lua/5.1/?.lua;${lgi}/share/lua/5.1/?/init.lua;${luajit}/share/lua/5.1/\?.lua;${luajit}/share/lua/5.1/?/init.lua"
      --prefix LUA_CPATH : "./?.so;${lgi}/lib/lua/5.1/?.so;${luajit}/lib/lua/5.1/?.so;${luajit}/lib/lua/5.1/loadall.so"
    )
  '';

  postFixup = ''
    wrapProgram $out/bin/sobercookie \
      --prefix PATH : ${lib.makeBinPath [bash]}
  '';
}
