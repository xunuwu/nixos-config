{
  outputs = {
    self,
    flake-parts,
    nixpkgs,
    ...
  } @ inputs: let
    mylib = import ./lib nixpkgs.lib;
    systemProfiles = mylib.loadTree2 ./sys/profiles;
    homeProfiles = mylib.loadTreeInf ./home/profiles;
    homeSuites = mylib.loadBranch ./home/suites;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      flake._mylib = mylib; # for debugging :3
      flake.nixosConfigurations = mylib.loadConfigurations ./sys/machines {
        inherit inputs self systemProfiles homeProfiles homeSuites;
      };

      perSystem = {pkgs, ...}: {
        imports = [
          ./shells
          ./pkgs
        ];

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

    nvim-nix.url = "github:xunuwu/nvim-nix";
    nvim-nix.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "nixpkgs";

    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";

    sobercookie.url = "github:xunuwu/sobercookie";
    sobercookie.inputs.nixpkgs.follows = "nixpkgs";
  };
}
