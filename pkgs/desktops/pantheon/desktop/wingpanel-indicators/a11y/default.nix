{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
, python3
, vala
, granite
, gtk3
, libgee
, wingpanel
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-a11y";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1adx1sx9qh02hjgv5h0gwyn116shjl3paxmyaiv4cgh6vq3ndp3c";
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
    python3
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    wingpanel
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Universal Access Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-a11y";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
