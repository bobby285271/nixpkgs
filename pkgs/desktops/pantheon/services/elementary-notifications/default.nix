{ lib, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vala
, gtk3
, glib
, granite
, libgee
, libhandy
, libcanberra-gtk3
, pantheon
, python3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-notifications";
  version = "unstable-2020-07-14";

  repoName = "notifications";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = "3fff6ed8c604a0f799fd88bd4b5a844c0495ed65";
    sha256 = "1x30y31zqm1bkykms2gpjv5zxcd35hdl497lq5czd75yfz888z2l";
  };

  nativeBuildInputs = [
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libcanberra-gtk3
    libgee
    libhandy
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "GTK notification server for Pantheon";
    homepage = "https://github.com/elementary/notifications";
    license = licenses.gpl3Plus;
    maintainers = pantheon.maintainers;
    platforms = platforms.linux;
  };
}
