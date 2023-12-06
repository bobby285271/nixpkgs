{ lib
, stdenv
, substituteAll
, fetchpatch2
, fetchFromGitHub
, meson
, mesonEmulatorHook
, ninja
, pkg-config
, gettext
, xmlto
, docbook-xsl-nons
, docbook_xml_dtd_45
, libxslt
, libstemmer
, glib
, xapian
, libxml2
, libxmlb
, libyaml
, gobject-introspection
, pcre
, itstool
, gperf
, vala
, curl
, systemd
, nixosTests
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
}:

stdenv.mkDerivation rec {
  pname = "appstream";
  version = "1.0.0";

  outputs = [ "out" "dev" "installedTests" ];

  src = fetchFromGitHub {
    owner = "ximion";
    repo = "appstream";
    rev = "v${version}";
    sha256 = "sha256-9bqNHJiVYn64aZFBvX6eV4rPHbVo38BnQg9cj4udJL8=";
  };

  patches = [
    # Fix hardcoded paths
    (substituteAll {
      src = ./fix-paths.patch;
      libstemmer_includedir = "${lib.getDev libstemmer}/include";
    })

    # Allow installing installed tests to a separate output.
    ./installed-tests-path.patch

    # Workaround metadata validation issue with developer-name-tag-deprecated.
    # https://github.com/NixOS/nixpkgs/pull/272049#issuecomment-1848847290
    (fetchpatch2 {
      url = "https://github.com/ximion/appstream/commit/0e12d9840bef383c55b439d350649d95d8ef88f1.patch";
      hash = "sha256-ke+pSm22wvNxPifmoiXgV+EeDgpNDcGhsiytxy6BG3k=";
    })

    # Fix darwin build.
    # https://github.com/ximion/appstream/issues/551
    (fetchpatch2 {
      url = "https://github.com/ximion/appstream/commit/02ee2d0daaeda96b5a1800a48cbcf68fbb721374.patch";
      hash = "sha256-x+/Lx6/5/KQUCjq112paV/IzGY24APWc5+BYH5fYlNo=";
    })

    # Fix Qt5 build.
    # https://github.com/ximion/appstream/pull/554
    (fetchpatch2 {
      url = "https://github.com/ximion/appstream/commit/fed92f2a5420b3f2609007a44be7251e9602459e.patch";
      hash = "sha256-218LYEnK6FPOsNDYfJ9WTY4t46FRQv1cWzpxsD4JddQ=";
    })

    # In file included from ../src/as-system-info.c:60:
    # In file included from /nix/store/xxx-Libsystem-1238.60.2/include/sys/sysctl.h:83:
    # /nix/store/xxx-Libsystem-1238.60.2/include/sys/ucred.h:91:2: error: unknown type name 'u_long'
    ./fix-darwin-build.patch
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxslt
    xmlto
    docbook-xsl-nons
    docbook_xml_dtd_45
    gobject-introspection
    itstool
    vala
    gperf
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    libstemmer
    pcre
    glib
    xapian
    libxml2
    libxmlb
    libyaml
    curl
  ] ++ lib.optionals withSystemd [
    systemd
  ];

  mesonFlags = [
    "-Dapidocs=false"
    "-Ddocs=false"
    "-Dvapi=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ] ++ lib.optionals (!withSystemd) [
    "-Dsystemd=false"
  ];

  passthru = {
    tests = {
      installed-tests = nixosTests.installed-tests.appstream;
    };
  };

  meta = with lib; {
    description = "Software metadata handling library";
    longDescription = ''
      AppStream is a cross-distro effort for building Software-Center applications
      and enhancing metadata provided by software components.  It provides
      specifications for meta-information which is shipped by upstream projects and
      can be consumed by other software.
    '';
    homepage = "https://www.freedesktop.org/wiki/Distributions/AppStream/";
    license = licenses.lgpl21Plus;
    mainProgram = "appstreamcli";
    platforms = platforms.unix;
  };
}
