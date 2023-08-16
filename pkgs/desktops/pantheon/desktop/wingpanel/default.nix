{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, wrapGAppsHook
, pkg-config
, meson
, ninja
, vala
, gala
, gtk3
, libgee
, granite
, gettext
, mutter
, mesa
, json-glib
, python3
, elementary-gtk-theme
, elementary-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "wingpanel";
  version = "3.0.3-unstable-2023-04-24";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    # Needed for mutter 44 support.
    rev = "0cbf28917254366b08ef66a032687a2498e157ef";
    sha256 = "sha256-nxvefiUJw4ouLvbfLYrPNlkNya19k/g2Yaj0uxU2/lI=";
  };

  patches = [
    ./indicators.patch
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    gala
    granite
    gtk3
    json-glib
    libgee
    mutter
    mesa # for libEGL
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # this GTK theme is required
      --prefix XDG_DATA_DIRS : "${elementary-gtk-theme}/share"

      # the icon theme is required
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "The extensible top panel for Pantheon";
    longDescription = ''
      Wingpanel is an empty container that accepts indicators as extensions,
      including the applications menu.
    '';
    homepage = "https://github.com/elementary/wingpanel";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.wingpanel";
  };
}
