# patchelf --replace-needed libbinaryninjacore.so.1 ${symlinkJoin} $out/opt/binaryninja
{
  pkgs,
  self,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (ghidra.withExtensions (ps:
      with ps; [
        gnudisassembler
        machinelearning
      ]))

    self.packages.${pkgs.system}.binaryninja-personal
    self.packages.${pkgs.system}.ida-pro
    # (pkgs.callPackage ./il2cppdumper {})
    # (pkgs.callPackage ./ilspy {})
    gdb
  ];

  networking.hosts = {
    "0.0.0.0" = ["master.binary.ninja"]; # idk my binary ninja crack [AMPED] told me to
  };
}
