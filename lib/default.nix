l: let
  b = builtins;
in {
  loadConfigurations = dir: specialArgsFromHost:
    (b.mapAttrs (name: _:
      l.nixosSystem {
        modules = [(dir + /${name})];
        specialArgs = specialArgsFromHost name;
      })) (b.readDir dir);
}
