l: let
  b = builtins;
in rec {
  loadBranch = branch:
    l.mapAttrs' (leaf: _: {
      name = l.removeSuffix ".nix" leaf;
      value = /${branch}/${leaf};
    }) (b.readDir /${branch});

  loadTree2 = dir: (l.mapAttrs (branch: _: loadBranch /${dir}/${branch})) (b.readDir dir);

  loadTreeInf = dir:
    l.mapAttrs' (
      name: value: {
        name = l.removeSuffix ".nix" name;
        value =
          if value == "directory"
          then loadTreeInf (dir + /${name})
          else (dir + /${name});
      }
    ) (b.readDir dir);

  loadConfigurations = dir: specialArgs:
    (b.mapAttrs (name: _:
      l.nixosSystem {
        modules = [(dir + /${name})];
        inherit specialArgs;
      })) (b.readDir dir);
}
