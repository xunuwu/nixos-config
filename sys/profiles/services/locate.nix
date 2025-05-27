{lib, ...}: {
  services.locate = {
    enable = true;
    pruneNames = lib.mkOptionDefault [".jj"];
  };
}
