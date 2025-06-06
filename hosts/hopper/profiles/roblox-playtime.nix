{
  inputs,
  config,
  ...
}: {
  imports = [inputs.roblox-playtime.nixosModules.roblox-playtime];

  services.roblox-playtime = {
    enable = true;
    configFile = config.sops.secrets.roblox-playtime.path;
  };

  environment.persistence."/persist".directories = ["/var/lib/roblox-playtime"];
  services.restic.backups.hopper.paths = ["/var/lib/roblox-playtime"];
}
