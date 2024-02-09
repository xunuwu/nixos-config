remote OPERATION HOST:
  nixos-rebuild \
  --flake .#{{HOST}} \
  --target-host xun@{{HOST}} \
  --use-remote-sudo \
  {{OPERATION}}
