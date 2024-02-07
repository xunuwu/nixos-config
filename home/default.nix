{
  lib,
  self,
  inputs,
  ...
}: {
  imports = [
  ];

  home = {
    username = "xun";
    homeDirectory = "/home/xun";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;
}
