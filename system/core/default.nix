{
  self,
  super,
  root,
}: {
  imports = [
    super.security
    super.users
    super.ssh
    super.locale
    root.nix.default
    root.programs.zsh
  ];
}
