{ lib
, mkXfceDerivation
, libxfce4util
, gobject-introspection
, vala
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.19.2";

  sha256 = "sha256-8GwG3IE4glX8K1znxdpEbuAgxnWk7d2Ec9BCn5WrnQ8=";

  nativeBuildInputs = [ gobject-introspection vala ];

  buildInputs = [ libxfce4util ];

  meta = with lib; {
    description = "Simple client-server configuration storage and query system for Xfce";
    mainProgram = "xfconf-query";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
