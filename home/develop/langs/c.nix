{pkgs, ...}: {
  home.packages = with pkgs; [
    clang-tools
    buckle
    valgrind
    gdb
    lldb
    lld
  ];
}
