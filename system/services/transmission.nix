{
  lib,
  config,
  self,
  ...
}: {
  services.transmission = {
    enable = true;
  };
}
