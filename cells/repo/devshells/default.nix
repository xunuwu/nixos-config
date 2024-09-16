{
  inputs,
  cell,
}: let
  inherit
    (inputs)
    nixpkgs
    hive
    std
    colmena
    ;
  inherit (nixpkgs) lib;
  inherit (hive.bootstrap.shell) bootstrap;
  inherit (std.lib) dev;
in {
  default = dev.mkShell {
    name = "Hive";

    imports = [bootstrap];

    commands = lib.concatLists [
      (map (x: {package = x;}) (with nixpkgs; [
        std.std.cli.default
        nixpkgs.colmena # colmena.packages.colmena
        sops
        ssh-to-age
      ]))
    ];
  };
}
