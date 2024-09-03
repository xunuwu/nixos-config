{lib, ...}: {
  imports = [
    ./security.nix
    ./users.nix
    ./ssh.nix
    ./locale.nix
    ../nix
    ../programs/zsh.nix
  ];
}
