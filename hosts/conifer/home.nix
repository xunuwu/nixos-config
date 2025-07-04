{
  homeProfiles,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = with homeProfiles; [
    cli.fish

    cli.xdg
    cli.direnv
    cli.tmux
    cli.git
    cli.github
    cli.forgejo
    cli.jujutsu
    cli.comma

    programs.nvim

    desktop.xdg-portals

    develop.common
    develop.docs

    develop.langs.c
    develop.langs.nix
  ];

  programs = {
    starship.enable = true;
    zoxide.enable = true;
    lazygit.enable = true;
  };
  home.packages = with pkgs; [
    # coding
    tokei
    devenv
    lazyjj
    jjui
  ];

  home = {
    username = "xun";
    homeDirectory = "/home/xun";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  programs.home-manager.enable = true;
}
