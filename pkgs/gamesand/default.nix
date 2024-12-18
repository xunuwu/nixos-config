{
  steam-fhsenv-without-steam,
  symlinkJoin,
}:
symlinkJoin {
  name = "gamesand";
  paths = [
    (steam-fhsenv-without-steam.override
      {
        extraBwrapArgs = [
          "--bind ./files /game/files"
          "--bind ./appdata /home/$USER"
          "--chdir /game"
          "--ro-bind ./start.sh /game/start.sh"
          "--cap-add ALL"
        ];
      })
    .run
  ];
  postBuild = ''
    mv $out/bin/steam-run $out/bin/gamesand
    sed -i 's/ignored=(\/nix \/dev \/proc \/etc )/ignored=(\/nix \/dev \/proc \/etc \/home )/' $out/bin/gamesand
  '';
}
