{
  self,
  super,
  root,
}: {
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    super.nixpkgs
    super.substituters
  ];

  # git is needed for flakes
  environment.systemPackages = [pkgs.git];

  nix = {
    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    # set the path for channels compat
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    settings = {
      #auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["flakes" "nix-command"];

      # for direnv GC roots
      keep-outputs = true;
      keep-derivations = true;

      trusted-users = ["root" "@wheel"];
    };
  };
}
