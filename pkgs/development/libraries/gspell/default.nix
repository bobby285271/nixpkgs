{
  stdenv,
  lib,
  fetchurl,
  docbook-xsl-nons,
  glib,
  gobject-introspection,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk3,
  icu,
  enchant2,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gspell";
  version = "1.13.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "zO1F6Ykro1wxuaEdYqnhVC5d/Wj3+zfDNbp0SfIM1hU=";
  };

  patches = [
    ./test.patch
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    glib # glib-mkenums
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gtk3
    icu
  ];

  propagatedBuildInputs = [
    # required for pkg-config
    enchant2
  ];

  # Meson version of https://github.com/Homebrew/homebrew-core/blob/2a27fb86b08afc7ae6dff79cf64aafb8ecc93275/Formula/gspell.rb#L125-L149
  # Dropped the GTK_MAC_* changes since gtk-mac-integration is not needed since 1.12.1
  mesonFlags = lib.optionals stdenv.isDarwin [ "-Dc_args=-xobjective-c" ];
  env = lib.optionalAttrs stdenv.isDarwin {
    NIX_LDFLAGS = toString [ "-framework Cocoa" ];
  };

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Spell-checking library for GTK applications";
    mainProgram = "gspell-app1";
    homepage = "https://gitlab.gnome.org/GNOME/gspell";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
