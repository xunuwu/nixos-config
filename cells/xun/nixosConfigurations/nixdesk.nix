{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  networking.hostName = "nixdesk";
  bee = {
    system = "x86_64-linux";
    pkgs = nixpkgs;
  };

  system.stateVersion = "23.11";
}
