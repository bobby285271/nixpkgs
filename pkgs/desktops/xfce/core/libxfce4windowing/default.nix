{ lib
, mkXfceDerivation
, gobject-introspection
, wayland-scanner
, glib
, gtk3
, libdisplay-info
, libwnck
, libX11
, libXrandr
, wayland
, wayland-protocols
, wlr-protocols
}:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4windowing";
  version = "4.19.7";

  sha256 = "sha256-a5oUtBH8ZfzeBuRZG4qrJCGvNxLsH1Vhxbvbd5wLvl4=";

  nativeBuildInputs = [
    gobject-introspection
    wayland-scanner
  ];

  buildInputs = [
    glib
    gtk3
    libdisplay-info
    libwnck
    libX11
    libXrandr
    wayland
    wayland-protocols
    wlr-protocols
  ];

  meta = {
    description = "Windowing concept abstraction library for X11 and Wayland";
    license = lib.licenses.lgpl21Plus;
    maintainers = lib.teams.xfce.members;
  };
}
