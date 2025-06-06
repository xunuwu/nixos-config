hostname := `hostname`

local OPERATION *FLAGS:
  nixos-rebuild \
  --flake .#{{hostname}} \
  --use-remote-sudo \
  {{FLAGS}} \
  {{OPERATION}}

updatekeys:
  fd . sys/profiles/secrets -E '*.nix' -t f -x sops updatekeys -y

remote OPERATION HOST REMOTEHOST *FLAGS:
  nixos-rebuild \
  --fast \
  --flake .#{{HOST}} \
  --target-host {{REMOTEHOST}} \
  --use-remote-sudo \
  {{FLAGS}} \
  {{OPERATION}}
