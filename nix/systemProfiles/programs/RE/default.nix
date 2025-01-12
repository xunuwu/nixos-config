# patchelf --replace-needed libbinaryninjacore.so.1 ${symlinkJoin} $out/opt/binaryninja
{
  pkgs,
  self,
  ...
}: {
  environment.systemPackages = let
    il2cppdumper = pkgs.callPackage ./il2cppdumper {};
    ilspy = pkgs.callPackage ./ilspy {};
  in
    with pkgs; [
      (ghidra.withExtensions (ps:
        with ps; [
          gnudisassembler
          machinelearning
        ]))

      # (cutter.withPlugins (ps:
      #   with ps; [
      #     rz-ghidra
      #   ]))

      self.packages.${pkgs.system}.binaryninja-personal
      self.packages.${pkgs.system}.ida-pro
      # il2cppdumper
      # ilspy
      gdb
    ];

  networking.hosts = {
    "0.0.0.0" = ["master.binary.ninja"]; # idk my binary ninja crack [AMPED] told me to
  };
}
## NOTE: you still need to run keygen.exe to generate a key

