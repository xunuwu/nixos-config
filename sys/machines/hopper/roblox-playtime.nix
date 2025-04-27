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
}
