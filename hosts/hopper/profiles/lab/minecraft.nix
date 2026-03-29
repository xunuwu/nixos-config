{
  inputs,
  pkgs,
  ...
}: let
  modpackZip = pkgs.fetchurl {
    url = "https://git.xunuwu.xyz/xun/nixos-config/releases/download/create-ultimate-thing-full/Create%20Ultimate%20Selection%202%20Serverpack%20MC%201.21.1-5.3.0.zip";
    name = "Create Ultimate Selection 2 MC 1.21.1-5.3.0.zip";
    hash = "sha256-xDChlZWivNNjYnmSCUIyrxfvqXAHrbvql7jyEDvVXvA=";
  };
  neoforge = inputs.nix-minecraft.legacyPackages.${pkgs.stdenv.hostPlatform.system}.neoforgeServers.neoforge-1_21_1;
  serverPackage = pkgs.stdenv.mkDerivation {
    name = "minecraft-createpack-server";
    nativeBuildInputs = [pkgs.unzip];
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out
      cp -r ${neoforge}/* $out/

      unzip ${modpackZip} -d temp
      cp -r temp/* $out/ 2>/dev/null || true
      rm -rf temp
    '';
  };
in {
  users.users.minecraft-createpack = {
    isSystemUser = true;
    group = "minecraft-createpack";
  };
  users.groups.minecraft-createpack = {};

  networking.firewall.allowedTCPPorts = [25565];
  networking.firewall.allowedUDPPorts = [24454];

  systemd.tmpfiles.rules = [
    "d /srv/minecraft            0755 root                 root                 - -"
    "d /srv/minecraft/createpack 0770 minecraft-createpack minecraft-createpack - -"
    "Z /srv/minecraft/createpack -    minecraft-createpack minecraft-createpack - -"
  ];
  systemd.services.minecraft-createpack = {
    enable = false;

    description = "Minecraft Create Ultimate Selection 2 Server";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      User = "minecraft-createpack";
      Group = "minecraft-createpack";
      WorkingDirectory = "/srv/minecraft/createpack";
      Restart = "always";
      RestartSec = "5s";
      ExecStart = ''
        ${pkgs.jdk21}/bin/java \
          @user_jvm_args.txt \
          @libraries/net/neoforged/neoforge/21.1.219/unix_args.txt \
          nogui
      '';
    };
    preStart = ''
      set -euo pipefail
      echo "=== minecraft-createpack preStart ==="

      for dir in world logs crash-reports backups screenshots; do
        if [ -d "$dir" ]; then
          mv "$dir" "../$dir-tmp" 2>/dev/null || true
        fi
      done

      ${pkgs.rsync}/bin/rsync -a --delete \
        --exclude='world' --exclude='logs' --exclude='crash-reports' \
        --exclude='backups' --exclude='screenshots' \
        --exclude='user_jvm_args.txt' --exclude='server.properties' --exclude='eula.txt' \
        ${serverPackage}/ ./

      for dir in world logs crash-reports backups screenshots; do
        if [ -d "../$dir-tmp" ]; then
          mv "../$dir-tmp" "$dir"
        fi
      done

      chown -R minecraft-createpack:minecraft-createpack .
      chmod -R u+rwX .

      echo "eula=true" > eula.txt

      cat > server.properties <<'EOF'
      motd=createpack!!
      max-players=5
      difficulty=normal
      allow-flight=true
      view-distance=16
      EOF

      cat > user_jvm_args.txt <<'EOF'
      -Xms1024M
      -Xmx4096M
      EOF

      echo "=== preStart finished ==="
    '';
  };

  services.minecraft-servers = {
    enable = false;
    eula = true;
    openFirewall = true;
    managementSystem.systemd-socket.enable = true;
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
