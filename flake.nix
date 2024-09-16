{
  outputs = {
    self,
    std,
    hive,
    ...
  } @ inputs: let
    collect-unrenamed = hive.collect // {renamer = _: target: target;};
  in
    hive.growOn {
      inherit inputs;

      systems = [
        "x86_64-linux"
      ];

      cellsFrom = ./cells;

      cellBlocks = with hive.blockTypes;
      with std.blockTypes; [
        (devshells "devshells")

        (functions "hardwareProfiles")
        (functions "userProfiles")

        nixosConfigurations
        # colmenaConfigurations
      ];
    }
    {
      devShells = hive.harvest self ["repo" "devshells"];
    }
    {
      nixosConfigurations = collect-unrenamed self "nixosConfigurations";
      # colmena = collect-unrenamed self "colmena";
    };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
    nixpkgs.follows = "nixpkgs-unstable";

    std = {
      url = "github:divnix/std";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        devshell.url = "github:numtide/devshell";
      };
    };

    hive = {
      url = "github:divnix/hive";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  nixConfig = {
    extra-experimental-settings = "nix-command flakes";

    extra-substituters = [
      "https://colmena.cachix.org"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
    ];
  };
}
