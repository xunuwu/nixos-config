{pkgs, ...}: {
  home.packages = with pkgs; [
    ghc
    haskell-language-server
    cabal-install
    hlint
    haskellPackages.retrie
  ];
}
