{pkgs, ...}: {
  documentation = {
    dev.enable = true;
    man.generateCaches = true;
    man = {
      man-db.enable = false;
      mandoc.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    linux-manual
    man-pages
    man-pages-posix
  ];
}
