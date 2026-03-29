{pkgs, ...}: {
  documentation = {
    dev.enable = true;

    man.cache.enable = true;
    man.cache.generateAtRuntime = true;
  };
  environment.systemPackages = with pkgs; [
    # linux-manual
    man-pages
    man-pages-posix
  ];
}
