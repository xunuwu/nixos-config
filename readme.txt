config files for my puters

hosts:
  nixdesk  - desktop (5600x, 6700 xt, 16gb, 2tb)
  conifer  - wsl (desktop & school laptop)
  hopper   - server (old hp with i5 2400, 8gb ram)
  rackserv - cheap 2gb vps

stack:
  sops-nix for secrets, currently stored in git repo and encrypted with ssh keys, might move to hashicorp vault/openbao eventually
  deployments with nixos-rebuild (see Justfile), it works ig
