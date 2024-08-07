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
      ];
      flake = {
      };
      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            nil
            git
            just
            home-manager
            sops
            colmena
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
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    sops-nix.url = "github:Mic92/sops-nix";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    ## deduplication
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    small-nvim.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.inputs = {
      nixpkgs.follows = "nixpkgs";
      nixpkgs-stable.follows = "nixpkgs";
    };

    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
  };
}
