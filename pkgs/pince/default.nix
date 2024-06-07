{
  lib,
  python3,
  python3Packages,
  wrapGAppsHook,
  gobject-introspection,
  gtk3,
  cmake,
  fetchgit,
  qt6,
  git,
  gdb,
  xorg,
  xcb-util-cursor,
}: let
  libptrscan = builtins.fetchTarball {
    url = "https://github.com/kekeimiku/PointerSearcher-X/releases/download/v0.7.3-dylib/libptrscan_pince-x86_64-unknown-linux-gnu.tar.gz";
    sha256 = "sha256:1as9hjp1xf3mfsxyaw5lxibmxr73nhnbgsxabvg34df7g9ihfq3f";
  };
in
  python3Packages.buildPythonApplication rec {
    pname = "PINCE";
    version = "0.1";
    format = "other";
    #src = fetchFromGitHub {
    #  owner = "korcankaraokcu";
    #  repo = "PINCE";
    #  rev = "823b213c531d9ffda1aa2b6504bc8a9eefc0c27f";
    #  hash = "sha256-4MTdr4++1tVfXg/t58kcILi2zS83T4IwqgKKXh0Kx3Q=";
    #};
    src = fetchgit {
      url = "https://github.com/korcankaraokcu/PINCE";
      rev = "823b213c531d9ffda1aa2b6504bc8a9eefc0c27f";
      hash = "sha256-5jcxWMJHoqCIFLgMyygZ3uh5WfkD0pjiqWg1iKzdwZc=";
      leaveDotGit = true;
    };

    dontUseCmakeConfigure = true;
    dontWrapPythonPrograms = true;
    dontWrapGApps = true;

    patchPhase = ''
      # Remove ".venv/PINCE" exist check
      sed -i '/^if \[ ! -d "\.venv\/PINCE" \]; /,/activate$/ s/^/# /' "./PINCE.sh"
      sed -i '$s/.venv\/PINCE\/bin\/python3/${lib.escape ["/"] (toString python3)}\/bin\/python3/g' "./PINCE.sh"
      sed -i 's/#!\/bin\/bash/#!\/bin\/sh/' "./PINCE.sh"

      sed -i 's/\/bin\/gdb/gdb/g' "libpince/typedefs.py"

      # Create a simple start script
      cat > pince <<- SHELL
      	#!/usr/bin/env bash

      	sh PINCE.sh "\$@"

      	read -p "Press enter to exit..."

      SHELL
    '';

    buildPhase = ''
      runHook preBuild

      sed -i 's/git submodule.*//g' install.sh
      . <(sed -n '/^exit_on_error() /,/^}/p' install.sh)
      . <(sed -n '/^set_install_vars() /,/^}/p' install.sh)
      . <(sed -n '/^compile_translations() /,/^}/p' install.sh)
      . <(sed -n '/^compile_libscanmem() /,/^}/p' install.sh)
      . <(sed -n '/^install_libscanmem() /,/^}/p' install.sh)

      install_libscanmem || exit_on_error

      mkdir -p libpince/libptrscan
      cp ${libptrscan}/ptrscan.py libpince/libptrscan/
      cp ${libptrscan}/libptrscan_pince.so libpince/libptrscan/libptrscan.so

      LRELEASE_CMD=${qt6.qttools}/bin/lrelease compile_translations || exit_on_error

      runHook postBuild
    '';

    fixupPhase = ''
      runHook preFixup

      makeWrapper ${lib.getExe python3} $out/bin/PINCE \
         "''${gappsWrapperArgs[@]}" \
         --set PYTHONPATH "${python3Packages.makePythonPath (with python3Packages; [
        pexpect
        pyqt6
        distorm3
        keystone-engine
        pygdbmi
        keyboard
        pygobject3
      ])}" \
        --suffix PATH : "${lib.makeBinPath [
        gdb
        qt6.full
      ]}" \
         --add-flags "$out/share/pince/PINCE.py"

      runHook postFixup
    '';

    nativeBuildInputs = [
      wrapGAppsHook
      git
      cmake
      gobject-introspection
    ];
    buildInputs = [
      python3
    ];
    propagatedBuildInputs = with python3Packages; [
      qt6.full
      xorg.libxcb
      xcb-util-cursor
      gtk3
      pyqt6
      pexpect
      distorm3
      keystone-engine
      pygdbmi
      keyboard
      pygobject3
      gdb
    ];
    installPhase = ''
      mkdir -p $out/share/pince
      cp -r . $out/share/pince
    '';
  }
