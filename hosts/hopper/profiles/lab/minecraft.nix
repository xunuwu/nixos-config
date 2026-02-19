{
  inputs,
  pkgs,
  ...
}: {
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.createpack = let
      modpackZip = pkgs.fetchurl {
        url = "https://git.xunuwu.xyz/xun/nixos-config/releases/download/create-ultimate-bundle-thing/Create%20Ultimate%20Selection%202%20MC%201.21.1-5.2.0.zip";
        name = "Create Ultimate Selection 2 MC 1.21.1-5.2.0.zip";
        hash = "sha256-+ykE2GE5lWQVLfcKyleKmQ+GXC+yN54yIgh7mPxxj4g="; # Replace with actual hash: run `nix-prefetch-url --name 'Create Ultimate Selection 2 MC 1.21.1-5.2.0.zip' 'https://www.curseforge.com/minecraft/modpacks/create-ultimate-selection-2/download/7634594/file'` and paste the output here
      };
      baseModpack = inputs.nix-minecraft.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fetchPackwizModpack {
        src = ./create-ultimate-selection-2;
        packHash = "sha256-0i4RWfJLWayYkefzeePbQY48nr/TdbX/sUVFfppkKvM="; # Leave empty initially; update with the correct value after the first failed build (see instructions below)
      };
      modpack = baseModpack.overrideAttrs (old: {
        buildPhase =
          ''
            cp ${modpackZip} "Create Ultimate Selection 2 MC 1.21.1-5.2.0.zip"
          ''
          + old.buildPhase;
      });
    in {
      enable = true;
      package = inputs.nix-minecraft.legacyPackages.${pkgs.stdenv.hostPlatform.system}.neoforgeServers.neoforge-1_21_1;
      serverProperties = {
        motd = "createpack!!";
        max-players = 5;
        difficulty = "normal";
        allow-flight = true;
        view-distance = 16;
      };
      jvmOpts = "-Xms1024M -Xmx6144M";
      symlinks.mods = "${modpack}/mods";
    };
    servers.owo = {
      enable = false;
      package = inputs.nix-minecraft.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fabricServers.fabric-1_21_5;
      serverProperties = {
        max-players = 5;
        motd = "owo";
        difficulty = "normal";
        allow-flight = true;
        view-distance = 16;
      };
      jvmOpts = "-Xms1024M -Xmx4096M";
      symlinks.mods = pkgs.linkFarmFromDrvs "mods" (
        builtins.attrValues {
          Fabric-API = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/hBmLTbVB/fabric-api-0.121.0%2B1.21.5.jar";
            hash = "sha256-GbKETZqAN5vfXJF0yNgwTiogDAI434S3Rj9rZw6B53E=";
          };
          Lithium = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/VWYoZjBF/lithium-fabric-0.16.2%2Bmc1.21.5.jar";
            hash = "sha256-XqvnQxASa4M0l3JJxi5Ej6TMHUWgodOmMhwbzWuMYGg=";
          };
          FerriteCore = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/uXXizFIs/versions/CtMpt7Jr/ferritecore-8.0.0-fabric.jar";
            hash = "sha256-K5C/AMKlgIw8U5cSpVaRGR+HFtW/pu76ujXpxMWijuo=";
          };
          C2ME = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/VSNURh3q/versions/VEjpHAOG/c2me-fabric-mc1.21.5-0.3.2%2Brc.1.0.jar";
            hash = "sha256-D7Ho8N4vZwHeacmfNe8YMcxsQCSlyNWFsxOp2b+vujE=";
          };
          Krypton = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/neW85eWt/krypton-0.2.9.jar";
            hash = "sha256-uGYia+H2DPawZQxBuxk77PMKfsN8GEUZo3F1zZ3MY6o=";
          };
        }
      );
    };
  };

  environment.persistence."/persist".directories = ["/srv/minecraft"];
  services.restic.backups.hopper.paths = ["/srv/minecraft"];
}
