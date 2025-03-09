{pkgs, ...}: {
  home.packages = with pkgs; [
    (symlinkJoin {
      name = "idea-ultimate";
      paths = [jetbrains.idea-ultimate];
      buildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/idea-ultimate \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [libGL]}"
      '';
    })
  ];
}
