{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, appstream
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook
, clutter-gtk
, elementary-icon-theme
, evolution-data-server
, granite
, geoclue2
, geocode-glib
, gtk3
, libchamplain
, libgdata
, libgee
, libhandy
, libical
}:

stdenv.mkDerivation rec {
  pname = "elementary-tasks";
  version = "unstable-2021-07-20";

  repoName = "tasks";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = "9f827b63085fc7f2a4e92834059860abf217d5aa";
    sha256 = "13my4qzdzkdn3hc09w8f5i7q1iwsdq25v0i4i8awv77a1d03n7iq";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter-gtk
    elementary-icon-theme
    evolution-data-server
    granite
    geoclue2
    geocode-glib
    gtk3
    libchamplain
    libgdata
    libgee
    libhandy
    libical
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    homepage = "https://github.com/elementary/tasks";
    description = "Synced tasks and reminders on elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
