{
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {
      inherit inputs;
    } {
      systems = ["x86_64-linux"];
      imports = [
        ./home/profiles
        ./hosts
        ./modules
        ./home-modules
      ];
      flake = {
      };
      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            nil
            nixd
            git
            just
            home-manager
            sops
            colmena
            inputs.nvfetcher.packages.${pkgs.system}.default
          ];
          name = "dots";
        };

        packages = import ./pkgs {
          inherit pkgs;
        };

        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    hardware.url = "github:nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    small-nvim.url = "github:xunuwu/small-nvim";
    nur.url = "github:nix-community/NUR";
    sops-nix.url = "github:Mic92/sops-nix";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nvfetcher.url = "github:berberman/nvfetcher";

    ## deduplication
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    small-nvim.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs = {
      nixpkgs.follows = "nixpkgs";
      nixpkgs-stable.follows = "nixpkgs";
    };
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
    nvfetcher.inputs.nixpkgs.follows = "nixpkgs";
  };
}
