{
  pkgs,
  lib,
  ...
}: let
  shells = {
    silk-fhs = "with pkgs; [glfw libGL assimp wgpu-native]";
  };
in {
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "runsh";

      runtimeInputs = [pkgs.nix];

      text = ''
        ${lib.concatMapAttrsStringSep "\n" (name: value: ''
            runshell-${name}() {
              # shellcheck disable=SC2016
              nix shell --impure --expr '(import <nixpkgs> {}).buildFHSEnv {
                name = "devshell";
                runScript = "$SHELL";
                targetPkgs = pkgs: ${value};
              }' --command devshell
            }
          '')
          shells}
        if [ -z "''${1:-}" ]; then
          echo "available shells:"
          ${lib.concatMapAttrsStringSep "\n" (name: _: "echo ${name}") shells}
          exit
        fi

        case $1 in
        ${lib.concatMapAttrsStringSep "\n" (name: _: ''
            "${name}") runshell-${name} ;;
          '')
          shells}
          *) echo no such shell ;;
        esac
      '';
    })
  ];
}
