{
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {
      inherit inputs;
    } {
      systems = ["x86_64-linux"];
      imports = [
        ./home/profiles
        ./nix/machines
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
            git-agecrypt
            inputs.nvfetcher.packages.${pkgs.system}.default
          ];
          name = "dots";
        };

        packages = import ./pkgs {
          inherit pkgs;
        };

        formatter = pkgs.alejandra;
        # formatter = pkgs.nixfmt-rfc-style;
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    hardware.url = "github:nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    nvim-nix = {
      url = "github:xunuwu/nvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nvfetcher.url = "github:berberman/nvfetcher";
    microvm.url = "github:astro/microvm.nix";
    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";
    sobercookie.url = "github:xunuwu/sobercookie";
    ## deduplication
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs = {
      nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nvfetcher.inputs.nixpkgs.follows = "nixpkgs";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
  };
}
