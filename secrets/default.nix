{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./global
  ];
}
