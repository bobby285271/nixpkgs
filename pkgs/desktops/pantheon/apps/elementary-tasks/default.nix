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
  version = "6.0.0";

  repoName = "tasks";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1a1sra886xdrjp5kwa6fafyl2acnaarwk9sw4cw5qyvlrqrg04ds";
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
