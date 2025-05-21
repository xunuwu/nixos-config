l: let
  b = builtins;
in {
  loadConfigurations = dir: specialArgsFromHost:
    (b.mapAttrs (name: _:
      l.nixosSystem {
        modules = [(dir + /${name})];
        specialArgs = specialArgsFromHost name;
      })) (b.readDir dir);
  stripPort = url: builtins.match "(.*):[0-9]*" url |> builtins.head;
}
