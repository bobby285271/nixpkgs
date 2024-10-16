{ lib
, mkXfceDerivation
, libxfce4util
, gobject-introspection
, vala
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.19.3";

  sha256 = "sha256-voPAKqOvzMx+ycsoboxesmp3dNPg3FeK7/ih+RMP7b8=";

  nativeBuildInputs = [ gobject-introspection vala ];

  buildInputs = [ libxfce4util ];

  meta = with lib; {
    description = "Simple client-server configuration storage and query system for Xfce";
    mainProgram = "xfconf-query";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
