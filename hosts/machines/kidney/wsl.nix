{inputs, ...}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = "xun";
    startMenuLaunchers = true;
  };
}
