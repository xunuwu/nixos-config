# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  krunker = {
    pname = "krunker";
    version = "1626868370902057";
    src = fetchurl {
      url = "https://client2.krunker.io/setup.AppImage";
      sha256 = "sha256-yG8E3a6AaX0TBK23TlBBLmiCfqzS8FldTfl7As4Dcvo=";
    };
  };
}
