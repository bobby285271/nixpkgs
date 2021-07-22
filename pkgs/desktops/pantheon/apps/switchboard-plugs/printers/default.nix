{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, cups
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-printers";
  version = "2.1.10";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0frvybbx7mcs87kww0if4zn0c6c2gb400cpiqrl8b0294py58xpb";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    cups
    granite
    gtk3
    libgee
    switchboard
  ];

  meta = with lib; {
    description = "Switchboard Printers Plug";
    homepage = "https://github.com/elementary/switchboard-plug-printers";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
