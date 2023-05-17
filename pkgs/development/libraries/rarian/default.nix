{ stdenv
, lib
, fetchFromGitLab
, autoreconfHook
, pkg-config
, libxslt
, tinyxml
}:

stdenv.mkDerivation rec {
  pname = "rarian";
  version = "0.8.4";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "rarian";
    repo = "rarian";
    rev = version;
    hash = "sha256-IVbK5cusSdvBPrEuYafrst13FLBlxm3g1fKYGBDy0bM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libxslt
    tinyxml
  ];

  meta = with lib; {
    description = "Documentation metadata library based on the proposed Freedesktop.org spec";
    homepage = "https://rarian.freedesktop.org/";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
