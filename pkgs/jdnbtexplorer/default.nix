{
  lib,
  python3,
  which,
  qttools,
}: let
  myPython = python3.withPackages (pkgs:
    with pkgs; [
      pyqt6
      pyside6
      (myPython.pkgs.buildPythonPackage rec {
        pname = "NBT";
        version = "1.5.1";

        src = myPython.pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-2juyE3YFy53+dEbxPxmzrn+vkg1DCjh/t4794n9mNsU=";
        };
      })
    ]);
in
  myPython.pkgs.buildPythonPackage rec {
    pname = "jdNBTExplorer";
    version = "2.0";
    format = "pyproject";

    src = builtins.fetchGit {
      url = "https://codeberg.org/JakobDev/jdNBTExplorer";
      rev = "e70c9b030f88340b565c22759b6efd97172be551";
    };

    nativeBuildInputs = [
      myPython
      which
      qttools
    ];

    propagatedBuildInputs = [
      myPython
    ];

    dontWrapQtApps = true;

    preFixup = ''
      qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
      # You can manually patch scripts using: wrapQtApp "$out/bin/myapp". TODO: check when it's required.
    '';

    meta = with lib; {
      changelog = "https://codeberg.org/JakobDev/jdNBTExplorer/releases/tag/${version}";
      description = "An Editor for Minecraft NBT files";
      homepage = "https://codeberg.org/JakobDev/jdNBTExplorer";
      license = licenses.gpl3Only;
    };
  }
