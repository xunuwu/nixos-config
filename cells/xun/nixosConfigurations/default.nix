{
  inputs,
  cell,
}:
inputs.hive.findLoad {
  inherit cell inputs;
  block = ./.;
}
