{pkgs, ...}: {
  home.packages = with pkgs; [clang-tools buckle gdb lldb];
}
