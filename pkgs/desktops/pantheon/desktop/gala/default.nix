{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
, meson
, python3
, ninja
, vala
, desktop-file-utils
, gettext
, libxml2
, gtk3
, granite
, libgee
, libhandy
, bamf
, libcanberra-gtk3
, gnome-desktop
, mesa
, mutter
, gnome-settings-daemon
, wrapGAppsHook3
, sqlite
, systemd
}:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "7.1.3-unstable-2024-05-05";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "196d2498a257d8af48221b1999639bcce8b80eb1";
    sha256 = "sha256-UJ8T/oGUwSKV1L8sub8tpMLeeAfyNEk8PCqGnCGjyFA=";
  };

  patches = [
    # We look for plugins in `/run/current-system/sw/lib/` because
    # there are multiple plugin providers (e.g. gala and wingpanel).
    ./plugins-dir.patch

    # InternalUtils: Fix window placement
    # https://github.com/elementary/gala/pull/1913
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/2d30bee678788c5a853721d16b5b39c997b23c02.patch";
      hash = "sha256-vhGFaLpJZFx1VTfjY1BahQiOUvBPi0dBSXLGhYc7r8A=";
    })

    # BackgroundManager: Don't set visible
    # https://github.com/elementary/gala/pull/1910
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/e0e8bb7a70069719eb822aabd46dc66a38996e9e.patch";
      hash = "sha256-eYgvbbEVSjvwmH0AZJMKG5Kfv45tuYt85PwAxBEl468=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    gnome-settings-daemon
    gnome-desktop
    granite
    gtk3
    libcanberra-gtk3
    libgee
    libhandy
    mesa # for libEGL
    mutter
    sqlite
    systemd
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = "https://github.com/elementary/gala";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "gala";
  };
}
