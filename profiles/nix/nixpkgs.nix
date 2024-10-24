{
  self,
  super,
  root,
}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [];
  };
}
