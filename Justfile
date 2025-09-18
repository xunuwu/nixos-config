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

windows-searchengines:
  #!/usr/bin/env bash
  windows_username="$(cmd.exe /c echo %username% 2>/dev/null | dos2unix)"
  nix build .\#nixosConfigurations.nixdesk.config.home-manager.users.xun.programs.firefox.profiles.xun.search.file
  cp result "/mnt/c/Users/$windows_username/AppData/Roaming/Mozilla/Firefox/Profiles/ey682mc4.default-release/search.json.mozlz4"
