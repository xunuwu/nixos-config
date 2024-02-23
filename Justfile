hostname := `hostname`

local OPERATION:
  sudo nixos-rebuild \
  --flake .#{{hostname}} \
  {{OPERATION}}


remote OPERATION HOST HOSTNAME *FLAGS:
  nixos-rebuild \
  --fast \
  --flake .#{{HOST}} \
  --target-host xun@{{HOSTNAME}} \
  --use-remote-sudo \
  {{FLAGS}} \
  {{OPERATION}}
