{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, substituteAll
, meson
, ninja
, python3
, pkg-config
, vala
, granite
, libgee
, gettext
, gtk3
, appstream
, gnome-menus
, json-glib
, elementary-dock
, bamf
, switchboard-with-plugs
, libunity
, libsoup
, wingpanel
, zeitgeist
, bc
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-applications-menu";
  version = "2.8.0";

  repoName = "applications-menu";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1n0l384jrvakr3blbjriyg9ibmzm1wi7ds0dq9zy666v8yknm7zm";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    appstream
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    bamf
    elementary-dock
    gnome-menus
    granite
    gtk3
    json-glib
    libgee
    libhandy
    libsoup
    libunity
    switchboard-with-plugs
    wingpanel
    zeitgeist
  ] ++
  # applications-menu has a plugin to search switchboard plugins
  # see https://github.com/NixOS/nixpkgs/issues/100209
  # wingpanel's wrapper will need to pick up the fact that
  # applications-menu needs a version of switchboard with all
  # its plugins for search.
  switchboard-with-plugs.buildInputs;

  mesonFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      bc = "${bc}/bin/bc";
    })
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Lightweight and stylish app launcher for Pantheon";
    homepage = "https://github.com/elementary/applications-menu";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
