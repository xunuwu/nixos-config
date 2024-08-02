{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  powershell,
}:
buildDotnetModule rec {
  pname = "ilspy";
  version = "9.0-preview2";
  src = fetchFromGitHub {
    owner = "icsharpcode";
    repo = "ILSpy";
    rev = "v${version}";
    sha256 = "sha256-JaFyKq5ZyHLvodY2/Ybwb/FmDeWQ5BawmA1ss+Qry20=";
  };

  buildInputs = [
    powershell
  ];

  projectFile = "ICSharpCode.ILSpyCmd/ICSharpCode.ILSpyCmd.csproj";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nugetDeps = ./deps.nix;
}
