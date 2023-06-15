{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook4
, glib
, gtk4
}:

stdenv.mkDerivation rec {
  pname = "elementary-dock";
  version = "unstable-2023-06-15";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "dock";
    rev = "fc71528d7be78c794eba76b0b3107585ba1d1769"; # tintou/container
    sha256 = "sha256-I2623oHFH71s9hnjxuG54zr81dNC2+9eTVDHS5rEZUE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Elegant, simple, clean dock";
    homepage = "https://github.com/elementary/dock";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ] ++ teams.pantheon.members;
    mainProgram = "plank";
  };
}
