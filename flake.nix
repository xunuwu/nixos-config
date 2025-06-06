{
  outputs = {
    self,
    flake-parts,
    nixpkgs,
    haumea,
    ...
  } @ inputs: let
    systemProfiles = haumea.lib.load {
      src = ./sys/profiles;
      loader = haumea.lib.loaders.path;
    };
    homeProfiles = ./home;
    vars = import ./vars;
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
              ./secrets/${hostname}
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

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    own-website.url = "github:xunuwu/xunuwu.xyz";
    own-website.inputs.nixpkgs.follows = "nixpkgs";

    wallpaper.url = "file+https://cdn.donmai.us/original/43/20/__kasane_teto_and_kasane_teto_utau_and_1_more_drawn_by_maguru_white__43204cf49ef8c071c34009553d1c0455.jpg";
  };
}
