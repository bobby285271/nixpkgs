{
  lib,
  mkXfceDerivation,
  exo,
  gtk3,
  libxfce4ui,
  libxfce4util,
  libxfce4windowing,
  libyaml,
  xfconf,
  libnotify,
  garcon,
  gtk-layer-shell,
  thunar,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.19.5";
  rev = "56ddbe79e30b080f0ecfaeaa70fd7bc7f9befd8a";

  sha256 = "sha256-Fglm15tStulTg0BATfLYwGSQYwFyTas4gY7X0GCaHeo=";

  buildInputs = [
    exo
    gtk3
    libxfce4ui
    libxfce4util
    libxfce4windowing
    libyaml
    xfconf
    libnotify
    garcon
    gtk-layer-shell
    thunar
  ];

  separateDebugInfo = true;

  meta = with lib; {
    description = "Xfce's desktop manager";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
