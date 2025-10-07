{inputs, ...}: {
  imports = [inputs.nixos-wsl.nixosModules.default];
  wsl.enable = true;
  wsl.defaultUser = "xun";
  wsl.startMenuLaunchers = true;

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
