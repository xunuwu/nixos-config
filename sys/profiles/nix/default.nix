{inputs, ...}: {
  nix = {
    registry.nixpkgs.to = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      rev = inputs.nixpkgs.rev;
    };

    nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];

    settings = {
      builders-use-substitutes = true;
      keep-outputs = true;
      keep-derivations = true;
      accept-flake-config = true;
      use-xdg-base-directories = true;

      flake-registry = builtins.toFile "none.json" (builtins.toJSON {
        flakes = [];
        version = 2;
      });

      experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operators"
        "no-url-literals"
        "ca-derivations"
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];

      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://nix-community.cachix.org?priority=11"
        "https://nix-gaming.cachix.org?priority=12"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
  };
}
