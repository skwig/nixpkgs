{ stdenv, callPackage, fetchurl, lib, }:

let

  pname = "freelens";
  version = "1.2.1";

  sources = {
    x86_64-linux = {
      url =
        "https://github.com/freelensapp/freelens/releases/download/v1.2.1/Freelens-${version}-linux-amd64.AppImage";
      hash = "sha256-13i1r3jx8sxwyd9qznad8m6mlj48wzbm0idk3h25f1i1426vgmlw";
    };
    # TODO: arm64 linux

    # x86_64-darwin = {
    #   url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.dmg";
    #   hash = "sha256-MQQRGTCe+LEHXJi6zjnpENbtlWNP+XVH9rWXRMk+26w=";
    # };
    # aarch64-darwin = {
    #   url = "https://api.k8slens.dev/binaries/Lens-${version}-latest-arm64.dmg";
    #   hash = "sha256-aakJCLnQBAnUdrrniTcahS+q3/kP09mlaPTV8FW5afI=";
    # };
  };

  src = fetchurl {
    inherit (sources.${stdenv.system} or (throw
      "Unsupported system: ${stdenv.system}"))
      url hash;
  };

  meta = with lib; {
    description = "Freelens";
    homepage = "https://github.com/freelensapp/freelens/";
    license = licenses.lens;
    maintainers = with maintainers; [ dbirks RossComputerGuy starkca90 ];
    platforms = builtins.attrNames sources;
  };

in if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix { inherit pname version src meta; }
else
  callPackage ./linux.nix { inherit pname version src meta; }
