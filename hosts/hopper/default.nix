{
  inputs,
  systemProfiles,
  specialArgs,
  lib,
  ...
}: {
  imports =
    [
      inputs.hardware.nixosModules.common-cpu-intel
      inputs.vpn-confinement.nixosModules.default
      inputs.nix-minecraft.nixosModules.minecraft-servers
      inputs.impermanence.nixosModules.impermanence

      ./hardware.nix
      ./profiles/lab
      ./profiles/roblox-playtime.nix
      ./profiles/desktop.nix
      ./profiles/persistent.nix

      {
        home-manager = {
          backupFileExtension = "hm-backup";
          users.desktop.imports = [
            ./home.nix
            {home.stateVersion = "24.11";}
          ];
          extraSpecialArgs = specialArgs;
        };
      }
    ]
    ++ (map (x: systemProfiles + x) [
      /programs/home-manager.nix

      /core/security.nix
      /core/locale.nix
      /core/tools.nix
      /core/ssh.nix
      /core/deploy.nix

      /hardware/graphics.nix
      /hardware/steam-hardware.nix
      /hardware/bluetooth.nix

      /nix/nix.nix
      /nix/gc.nix

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
