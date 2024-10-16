{ lib
, mkXfceDerivation
, wayland-scanner
, exo
, garcon
, gtk3
, glib
, libnotify
, libxfce4ui
, libxfce4util
, libxklavier
, upower
, withUpower ? true
, xfconf
, xf86inputlibinput
, wlr-protocols
, colord
, withColord ? true
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-settings";
  version = "4.19.2";

  sha256 = "sha256-fHR1/ThRoP5tuwTTW3Ge98uhsC9M7WqpTza939KpuhU=";

  nativeBuildInputs = [
    wayland-scanner
  ];

  buildInputs = [
    exo
    garcon
    glib
    gtk3
    libnotify
    libxfce4ui
    libxfce4util
    libxklavier
    xf86inputlibinput
    xfconf
    wlr-protocols
  ]
  ++ lib.optionals withUpower [ upower ]
  ++ lib.optionals withColord [ colord ];

  configureFlags = [
    "--enable-pluggable-dialogs"
    "--enable-sound-settings"
  ]
  ++ lib.optionals withUpower [ "--enable-upower-glib" ]
  ++ lib.optionals withColord [ "--enable-colord" ];

  meta = with lib; {
    description = "Settings manager for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
