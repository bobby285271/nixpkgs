{ stdenv
, lib
, fetchFromGitLab
, gi-docgen
, gobject-introspection
, meson
, ninja
, pkg-config
, glib
, gnome-online-accounts
, json-glib
, librest
, libsoup
, uhttpmock
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmsgraph";
  version = "0-unstable-2024-01-30";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jbrummer";
    repo = "msgraph";
    rev = "a483db18ef2884d069ad0cf501a04f67950b5639";
    hash = "sha256-8nIjxAHttG4f8CytCCMNI/E+hwfX6eJeqO7LJBMCuTk=";
  };

  nativeBuildInputs = [
    gi-docgen
    gobject-introspection
    meson
    ninja
    pkg-config
  ];

  propagatedBuildInputs = [
    glib
    gnome-online-accounts
    json-glib
    librest
    libsoup
    uhttpmock
  ];

  mesonFlags = [
    "-Dc_args=-Wno-error=format-security"
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc/msgraph-0" "$devdoc"
  '';

  meta = with lib; {
    description = "Library to access MS Graph API for Office 365";
    homepage = "https://gitlab.gnome.org/jbrummer/msgraph";
    license = licenses.lgpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})
