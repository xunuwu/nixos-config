{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:
buildDotnetModule rec {
  pname = "il2cppdumper";
  version = "6.7.46";

  src = fetchFromGitHub {
    owner = "Perfare";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pMxxwBpuZ2EuP7O99XTJcnS3Dq8MdxvUGQHJ0U3bnTY=";
  };

  projectFile = "Il2CppDumper/Il2CppDumper.csproj";

  nugetDeps = ./deps.nix;

  dotnet-sdk = with dotnetCorePackages; combinePackages [sdk_7_0 sdk_6_0];
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  dotnetBuildFlags = [
    "-f"
    "net7.0"
  ];
  dotnetInstallFlags = dotnetBuildFlags;

  executables = [
    "Il2CppDumper"
  ];
}
