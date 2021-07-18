{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, fetchpatch
, pantheon
, pkg-config
, meson
, ninja
, vala
, gtk3
, granite
, wingpanel
, accountsservice
, libgee
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-session";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0hww856qjl4kjmmksd5gp8bc5vj4fhs2s9fmbnpbf88lg5ds0wv0";
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
    accountsservice
    granite
    gtk3
    libgee
    libhandy
    wingpanel
  ];

  meta = with lib; {
    description = "Session Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-session";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
