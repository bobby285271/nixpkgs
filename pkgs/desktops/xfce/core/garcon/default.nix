{ lib, mkXfceDerivation, gobject-introspection, gtk3, libxfce4ui, libxfce4util }:

mkXfceDerivation {
  category = "xfce";
  pname = "garcon";
  version = "4.19.1";

  sha256 = "sha256-XyOSQZ5OdzhThSw0in7cj7z9XczNTWCavUzbQ6qaL3g=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [ gtk3 libxfce4ui libxfce4util ];

  meta = with lib; {
    description = "Xfce menu support library";
    license = with licenses; [ lgpl2Only fdl11Only ];
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
