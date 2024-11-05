{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kmod,
}:
stdenv.mkDerivation {
  pname = "cartographer";
  version = "0.1";
  src = fetchFromGitHub {
    owner = "LWSS";
    repo = "Cartographer";
    rev = "";
  };
}
