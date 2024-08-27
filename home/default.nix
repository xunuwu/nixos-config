{
  imports = [
  ];

  home = {
    username = "xun";
    homeDirectory = "/home/xun";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;
}
