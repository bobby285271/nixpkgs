{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, gettext
, sassc
}:

stdenv.mkDerivation rec {
  pname = "elementary-gtk-theme";
  version = "2022-01-19";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "stylesheet";
    rev = "329ce1932c7a8d147baed17f691251bb785794f1";
    sha256 = "sha256-HBniuE0LmBWTK0uAWvZFpPlECpEZtE4b3CzVwHnXfbU=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    sassc
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "GTK theme designed to be smooth, attractive, fast, and usable";
    homepage = "https://github.com/elementary/stylesheet";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
