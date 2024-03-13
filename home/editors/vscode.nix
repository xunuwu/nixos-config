{
  pkgs,
  inputs,
  ...
}: let
  exts = inputs.nix-vscode-extensions.extensions.${pkgs.system};
  vsce = exts.vscode-marketplace;
  ovsx = exts.open-vsx;
in {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    package = pkgs.vscodium;

    mutableExtensionsDir = true;
    extensions = [
      ovsx.vadimcn.vscode-lldb
      ovsx.mkhl.direnv
      ovsx.editorconfig.editorconfig
      ovsx.pkief.material-icon-theme
      ovsx.eamodio.gitlens
      vsce.hediet.debug-visualizer
    ];
  };
}
