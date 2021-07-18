{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, meson
, python3
, ninja
, vala
, gtk3
, granite
, wingpanel
, evolution-data-server
, libical
, libgee
, libhandy
, libxml2
, libsoup
, libgdata
, elementary-calendar
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-datetime";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1mdm0fsnmmyw8c0ik2jmfri3kas9zkz1hskzf8wvbd51vnazfpgw";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    evolution-data-server
    granite
    gtk3
    libgee
    libhandy
    libical
    libsoup
    wingpanel
    libgdata # required by some dependency transitively
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Date & Time Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-datetime";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
