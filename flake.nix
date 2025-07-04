{
  outputs = {
    self,
    flake-parts,
    nixpkgs,
    haumea,
    ...
  } @ inputs: let
    _load = path:
      haumea.lib.load {
        src = path;
        loader = haumea.lib.loaders.path;
      };
    systemProfiles = _load ./sys/profiles;
    homeProfiles = _load ./home;
    vars = haumea.lib.load {
      src = ./vars;
      inputs.lib = nixpkgs.lib;
      transformer = haumea.lib.transformers.liftDefault;
    };
    l = nixpkgs.lib;
    b = builtins;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      flake.nixosConfigurations =
        b.readDir ./hosts
        |> b.mapAttrs (hostname: _:
          l.nixosSystem {
            modules = [
              ./hosts/${hostname}
              (
                if b.pathExists ./secrets/${hostname}
                then ./secrets/${hostname}
                else {}
              )
              inputs.sops-nix.nixosModules.sops
            ];
            specialArgs = {
              inherit inputs self systemProfiles homeProfiles vars;
            };
          });

      perSystem = {pkgs, ...}: {
        imports = [
          ./pkgs
        ];

        devShells.default = pkgs.mkShell {
          name = "dots";
          packages = with pkgs; [
            alejandra
            git
            just
            home-manager
            sops
          ];
        };

        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nvim-config.url = "github:xunuwu/nvim-config";
    nvim-config.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    haumea.url = "github:nix-community/haumea/v0.2.2";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";

    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";

    sobercookie.url = "github:xunuwu/sobercookie";
    sobercookie.inputs.nixpkgs.follows = "nixpkgs";

    wayland-appusage.url = "github:xunuwu/wayland-appusage";
    wayland-appusage.inputs.nixpkgs.follows = "nixpkgs";

    roblox-playtime.url = "github:xunuwu/roblox-playtime";
    roblox-playtime.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nixos-wsl.url = "github:nix-community/nixos-wsl";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    own-website.url = "git+https://git.xunuwu.xyz/xun/xunuwu.xyz";
    own-website.inputs.nixpkgs.follows = "nixpkgs";

    crosshair-overlay.url = "git+https://git.xunuwu.xyz/xun/crosshair-overlay";
    crosshair-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };
}
