{ lib, mkXfceDerivation, gobject-introspection, vala }:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4util";
  version = "4.19.3";
  rev = "fceecb4f15082ef89e1c5bf2f4fec27b8e240d53";

  sha256 = "sha256-K/jTi+uakSOhRzamdGVABAPdKjkvK7AOD61GxHG9hEI=";

  nativeBuildInputs = [ gobject-introspection vala ];

  meta = with lib; {
    description = "Extension library for Xfce";
    mainProgram = "xfce4-kiosk-query";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
