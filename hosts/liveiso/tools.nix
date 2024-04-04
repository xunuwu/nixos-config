{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    neovim
    parted
    gparted
  ];
}
