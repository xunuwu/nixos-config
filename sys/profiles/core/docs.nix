{pkgs, ...}: {
  documentation = {
    dev.enable = true;
    man.generateCaches = false; # this does slow down builds by quite a lot
  };
  environment.systemPackages = with pkgs; [
    linux-manual
    man-pages
    man-pages-posix
  ];
}
