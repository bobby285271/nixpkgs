{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gnome
, gtk3
, gdk-pixbuf
, librsvg
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "adwaita-icon-theme";
  version = "46.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "aq40B2Nu2YMV9AtU4enFaM1ojkoEx0+Y3O/yezg2CFI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gtk3
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedBuildInputs = [
    # For convenience, we can specify adwaita-icon-theme only in packages
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "adwaita-icon-theme";
      attrPath = "gnome.adwaita-icon-theme";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/adwaita-icon-theme";
    platforms = with platforms; linux ++ darwin;
    maintainers = teams.gnome.members;
    license = licenses.cc-by-sa-30;
  };
}
