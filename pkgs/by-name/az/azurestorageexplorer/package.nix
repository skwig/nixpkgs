{
  stdenv,
  lib,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  curl,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gnutar,
  gtk3,
  icu,
  libdrm,
  libunwind,
  libuuid,
  libxkbcommon,
  libgbm,
  nspr,
  nss,
  openssl,
  pango,
  systemd,
  wrapGAppsHook3,
  xorg,
  zlib,
}:
let
  desktopItem = makeDesktopItem {
    name = "azurestorageexplorer";
    desktopName = "Azure Storage Explorer";
    exec = "storage-explorer";
    icon = "azurestorageexplorer";
    categories = [
      "Development"
    ];
    mimeTypes = [
      "x-scheme-handler/storageexplorer"
    ];
    keywords = [
      "azurestorageexplorer"
      "storage-explorer"
    ];
  };
in
stdenv.mkDerivation rec {

  pname = "azurestorageexplorer";
  version = "1.40.0";

  desktopItems = [
    desktopItem
  ];

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";

    url = "https://github.com/microsoft/AzureStorageExplorer/releases/download/v1.40.0/StorageExplorer-linux-x64.tar.gz";
    sha256 = "sha256-lK1GjxDQUvJIt8dJXuZlczCo7eubf3sFyuEtoTqSPzc=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    wrapGAppsHook3
  ];

  # buildInputs = [
  #   libuuid
  #   at-spi2-core
  #   at-spi2-atk
  # ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/pixmaps
    cp ${targetPath}/app/out/app/icon.png $out/share/pixmaps/azurestorageexplorer.png

    runHook postInstall
  '';

  edition = "azurestorageexplorer";
  targetPath = "$out/${edition}";

  unpackPhase = ''
    mkdir -p ${targetPath}
    ${gnutar}/bin/tar xf $src --strip 1 -C ${targetPath}
  '';

  # sqltoolsserviceRpath = lib.makeLibraryPath [
  #   stdenv.cc.cc
  #   libunwind
  #   libuuid
  #   icu
  #   openssl
  #   zlib
  #   curl
  # ];

  # this will most likely need to be updated when azuredatastudio's version changes
  # sqltoolsservicePath = "${targetPath}/resources/app/extensions/mssql/sqltoolsservice/Linux/5.0.20240724.1";

  # rpath = lib.concatStringsSep ":" [
  #   (lib.makeLibraryPath [
  #     alsa-lib
  #     at-spi2-atk
  #     cairo
  #     cups
  #     dbus
  #     expat
  #     gdk-pixbuf
  #     glib
  #     gtk3
  #     libgbm
  #     nss
  #     nspr
  #     libdrm
  #     xorg.libX11
  #     xorg.libxcb
  #     xorg.libXcomposite
  #     xorg.libXdamage
  #     xorg.libXext
  #     xorg.libXfixes
  #     xorg.libXrandr
  #     xorg.libxshmfence
  #     libxkbcommon
  #     xorg.libxkbfile
  #     pango
  #     stdenv.cc.cc
  #     systemd
  #   ])
  #   targetPath
  #   sqltoolsserviceRpath
  # ];

  # preFixup = ''
  #   patchelf \
  #     --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
  #     ${targetPath}/${edition}
  #
  #   mkdir -p $out/bin
  #   makeWrapper \
  #     ${targetPath}/bin/${edition} \
  #     $out/bin/azuredatastudio \
  #     --set LD_LIBRARY_PATH ${rpath}
  # '';

  meta = {
    maintainers = with lib.maintainers; [ xavierzwirtz ];
    description = "TODO";
    homepage = "https://azure.microsoft.com/en-us/products/storage/storage-explorer";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    mainProgram = "storage-explorer";
  };
}
