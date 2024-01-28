{ stdenv
, lib
, fetchFromGitHub
, fetchpatch2
, substituteAll
, bash
, dbus
, glib
, docbook_xsl
, libxslt
, meson
, ninja
, pkg-config
, python3
, wrapGAppsNoGuiHook
, gnome
, gnome-desktop
, gsettings-desktop-schemas
, gtk3
, libepoxy
, libGL
, libICE
, libSM
, libX11
, json-glib
, xtrans
, systemd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-session";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-session";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mz+Yh3NK2Tag+MWVofFFXYYXspxhmYBD6YCiuATpZSI=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      gsettings = "${glib.bin}/bin/gsettings";
      dbusLaunch = "${dbus.lib}/bin/dbus-launch";
      bash = "${bash}/bin/bash";
    })

    # gsm-manager: Fix Inhibit DBus method handler
    # https://github.com/NixOS/nixpkgs/issues/226355
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/gnome-session/-/commit/fab1a3b91677035d541de2c141f8073c4057342c.patch";
      hash = "sha256-0AtBDRCCjQdw4d4Ed+l0dR4UAxh+whZF0f9Vbyn/1/M=";
    })
  ];

  nativeBuildInputs = [
    docbook_xsl
    libxslt
    meson
    ninja
    pkg-config
    python3
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    glib
    gnome-desktop
    gsettings-desktop-schemas
    gtk3
    libepoxy
    libGL
    libICE
    libSM
    libX11
    json-glib
    xtrans
    systemd
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  meta = {
    description = "Softish fork of gnome-session";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-session";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ bobby285271 federicoschonborn ];
    platforms = lib.platforms.linux;
  };
})
