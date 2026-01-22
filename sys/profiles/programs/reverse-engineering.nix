# patchelf --replace-needed libbinaryninjacore.so.1 ${symlinkJoin} $out/opt/binaryninja
{
  pkgs,
  self,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ghidra
    # (ghidra.withExtensions (ps:
    #   with ps; [
    #     gnudisassembler
    #     machinelearning
    #   ]))

    self.packages.${pkgs.stdenv.hostPlatform.system}.binaryninja-personal
    self.packages.${pkgs.stdenv.hostPlatform.system}.ida-pro
    gdb
  ];

  networking.hosts = {
    "0.0.0.0" = ["master.binary.ninja"]; # idk my binary ninja crack [AMPED] told me to
  };
}
