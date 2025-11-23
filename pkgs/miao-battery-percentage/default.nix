{
  rustPlatform,
  pkg-config,
  udev,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "miao-battery-percentage";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "xunuwu";
    repo = "miao-battery-percentage";
    rev = "e14e72dce9d946503676121759ce6130e42bb637";
    hash = "sha256-NXJv8dChKPv695XMvmm+Xh0VJ1jdRhbdGMCM0LVIiD8=";
  };
  cargoLock.lockFile = "${src}/Cargo.lock";

  nativeBuildInputs = [pkg-config];
  buildInputs = [udev];

  meta.mainProgram = "miao-battery-percentage";
}
