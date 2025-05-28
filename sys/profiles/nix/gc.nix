{
  lib,
  pkgs,
  ...
}: {
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };
  nix.optimise.automatic = true;

  systemd.services.remove-old-nix-gc-roots = let
    beforeDate = "last month";
  in {
    description = "Remove old nix gc roots";
    script = "exec ${lib.getExe pkgs.findutils} /nix/var/nix/gcroots/auto -not -newermt \"${beforeDate}\" -delete";
    serviceConfig.Type = "oneshot";
    before = ["nix-gc.service"];
    requiredBy = ["nix-gc.service"];
  };
}
