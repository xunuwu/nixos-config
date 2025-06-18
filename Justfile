local OPERATION *FLAGS:
  nixos-rebuild \
  --flake .# \
  --sudo \
  {{FLAGS}} \
  {{OPERATION}}

updatekeys:
  fd . secrets -E '*.nix' -t f -x sops updatekeys -y

remote OPERATION HOST REMOTEHOST *FLAGS:
  nixos-rebuild \
  --no-reexec \
  --flake .#{{HOST}} \
  --target-host {{REMOTEHOST}} \
  --sudo \
  {{FLAGS}} \
  {{OPERATION}}
