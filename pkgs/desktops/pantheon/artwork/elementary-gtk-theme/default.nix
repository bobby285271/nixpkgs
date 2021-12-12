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
  version = "2021-12-12";

  repoName = "stylesheet";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = "9b7122b07b3a1878501d13d842c54e83ef9061c6";
    sha256 = "sha256-5AJ5Qhx+IP5TvwcmDBh7h5B7Ft6ZJiGAodCQ+S7t2XI=";
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
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
