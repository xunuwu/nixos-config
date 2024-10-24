_: {pkgs, ...}: {
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  boot.kernelParams = ["amd_iommu=on" "iommu=pt"];
  environment.systemPackages = [pkgs.libvirt];
}
