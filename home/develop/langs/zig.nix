{pkgs, ...}: {
  home.packages = let
    zig_patched = pkgs.zig.overrideAttrs {patches = [./__zig_watch.patch];};
  in [
    zig_patched
    (pkgs.zls.override {zig_0_14 = zig_patched;})
  ];
}
