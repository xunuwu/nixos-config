{self, ...}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [];
  };
}
