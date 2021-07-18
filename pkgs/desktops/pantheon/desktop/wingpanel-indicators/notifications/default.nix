{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, meson
, ninja
, vala
, gtk3
, granite
, wingpanel
, libgee
, libhandy
, elementary-notifications
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-notifications";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1pvcpk1d2zh9pvw0clv3bhf2plcww6nbxs6j7xjbvnaqs7d6i1k2";
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
    elementary-notifications
    granite
    gtk3
    libgee
    libhandy
    wingpanel
  ];

  meta = with lib; {
    description = "Notifications Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-notifications";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
