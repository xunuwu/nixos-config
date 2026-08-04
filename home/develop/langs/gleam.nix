{pkgs, ...}: {
  home.packages = [pkgs.gleam pkgs.beamPackages.erlang];
}
