{ lib
, mkXfceDerivation
, polkit
, exo
, libxfce4util
, libxfce4ui
, libxfce4windowing
, xfconf
, iceauth
, gtk3
, gtk-layer-shell
, glib
, libwnck
, xfce4-session
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-session";
  version = "4.19.2";
  rev = "7333c5659021e2d1f0da67f895e4066068ac948d";

  outputs = [ "waylandsession" ];

  sha256 = "sha256-6IG8C4Nzzm7HZc0SExgzYA2N+k9wwH8q7yjjMY3pfLU=";

  buildInputs = [
    exo
    gtk3
    gtk-layer-shell
    glib
    libxfce4ui
    libxfce4util
    libxfce4windowing
    libwnck
    xfconf
    polkit
    iceauth
  ];

  postInstall = ''
    # To ensure the desktop file has consistent l10n status with the x11 session,
    # we copy the original (i.e. untranslated) file here.
    mkdir -p $waylandsession/share/wayland-sessions
    cp xfce-wayland.desktop.in $waylandsession/share/wayland-sessions/xfce-wayland.desktop
  '';

  configureFlags = [
    "--with-xsession-prefix=${placeholder "out"}"
    "--with-wayland-session-prefix=${placeholder "out"}"
  ];

  passthru = {
    # The x11 session file is manually created in the Xfce NixOS module.
    providedSessions = [ "xfce-wayland" ];
    xinitrc = "${xfce4-session}/etc/xdg/xfce4/xinitrc";
  };

  meta = with lib; {
    description = "Session manager for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
