{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, desktop-file-utils
, gtk4
, granite7
, python3
, libgee
, clutter-gtk
, json-glib
, libgda
, libgpod
, libhandy
, libnotify
, libpeas
, libsoup
, zeitgeist
, gst_all_1
, taglib
, libdbusmenu
, libsignon-glib
, libaccounts-glib
, elementary-icon-theme
, wrapGAppsHook4
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "elementary-music";
  version = "2022-01-20";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "music";
    rev = "58d6a7e2bb4a5e1216e6665141cc701933ec6077";
    sha256 = "sha256-poCdKrVD0VyZFJ9eeRAz4Y5RTVVwUpLgZDFVcUL/QT0=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook4
  ];

  buildInputs = with gst_all_1; [
    clutter-gtk
    elementary-icon-theme
    granite7
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
    gtk4
    json-glib
    libadwaita
    libaccounts-glib
    libdbusmenu
    libgda
    libgee
    libgpod
    libhandy
    libnotify
    libpeas
    libsignon-glib
    libsoup
    taglib
    zeitgeist
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Music player and library designed for elementary OS";
    homepage = "https://github.com/elementary/music";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.music";
  };
}
