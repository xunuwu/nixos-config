{
  services.ollama = {
    enable = true;
    environmentVariables = {
      HSA_OVERRIDE_GFX_VERSION = "10.3.0";
    };
    listenAddress = "127.0.0.1:11434";
  };
}
