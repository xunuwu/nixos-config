{
  inputs,
  systemProfiles,
  homeSuites,
  specialArgs,
  lib,
  ...
}: {
  imports =
    [
      inputs.hardware.nixosModules.common-cpu-intel
      inputs.vpn-confinement.nixosModules.default
      inputs.nix-minecraft.nixosModules.minecraft-servers

      ./hardware.nix
      ./lab
      ./roblox-playtime.nix
      ./desktop.nix

      {
        home-manager = {
          backupFileExtension = "hm-backup";
          users.desktop.imports = [
            (homeSuites + /hopper)
            {home.stateVersion = "24.11";}
          ];
          extraSpecialArgs = specialArgs;
        };
      }
    ]
    ++ (map (x: systemProfiles + x) [
      /secrets/default.nix
      /secrets/hopper/default.nix

      /programs/home-manager.nix

      /core/security.nix
      /core/locale.nix
      /core/tools.nix
      /core/ssh.nix
      /core/deploy.nix

      /hardware/graphics.nix
      /hardware/steam-hardware.nix
      /hardware/bluetooth.nix

      /nix/default.nix # TODO slim this down

      /network/tailscale.nix
      /network/avahi.nix
      /network/networkd.nix
    ]);

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"

        "stremio-shell"
        "stremio-server"
      ];
  };

  networking.hostName = "hopper";

  swapDevices = [];

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
