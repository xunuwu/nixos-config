hostname := `hostname`

local OPERATION *FLAGS:
  sudo nixos-rebuild \
  --flake .#{{hostname}} \
  {{FLAGS}} \
  {{OPERATION}}


buildiso *FLAGS:
  nix build .#nixosConfigurations.liveiso.config.system.build.isoImage {{FLAGS}}


remote OPERATION HOST HOSTNAME *FLAGS:
  nixos-rebuild \
  --fast \
  --flake .#{{HOST}} \
  --target-host xun@{{HOSTNAME}} \
  --use-remote-sudo \
  {{FLAGS}} \
  {{OPERATION}}
