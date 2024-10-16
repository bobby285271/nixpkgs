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

  sha256 = "sha256-Mf5S4wHK9IzGiFUE/CF7Z9kCwjAwlLLkDcicXABJlHY=";

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

  meta = with lib; {
    description = "Xfce's desktop manager";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
