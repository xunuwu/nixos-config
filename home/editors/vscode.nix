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
    extensions = with vsce; [
      vadimcn.vscode-lldb
      mkhl.direnv
      editorconfig.editorconfig
      pkief.material-icon-theme
      eamodio.gitlens
      hediet.debug-visualizer
    ];
  };
}
