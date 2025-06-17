{
  rustPlatform,
  pkg-config,
  udev,
}:
rustPlatform.buildRustPackage {
  pname = "keyboard-state";
  version = "0.1.0";

  src = ./source;
  cargoLock.lockFile = ./source/Cargo.lock;

  nativeBuildInputs = [pkg-config];
  buildInputs = [udev];

  meta.mainProgram = "keyboard-state";
}
