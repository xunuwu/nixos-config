hostname := `hostname`

local OPERATION *FLAGS:
  sudo nixos-rebuild \
  --flake .#{{hostname}} \
  {{FLAGS}} \
  {{OPERATION}}


remote OPERATION HOST HOSTNAME *FLAGS:
  nixos-rebuild \
  --fast \
  --flake .#{{HOST}} \
  --target-host xun@{{HOSTNAME}} \
  --use-remote-sudo \
  {{FLAGS}} \
  {{OPERATION}}
