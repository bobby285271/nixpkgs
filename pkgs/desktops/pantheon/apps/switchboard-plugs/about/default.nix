{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, substituteAll
, meson
, ninja
, pkg-config
, vala
, libgee
, libgtop
, libhandy
, granite
, gtk3
, switchboard
, elementary-feedback
, appcenter
, fwupd
, appstream
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-about";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0rlp52ylgz41c3s4q8zrrynfl0yihvbgb8cg9cz6ywdaaahi3asp";
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
    appstream
    fwupd
    granite
    gtk3
    libgee
    libgtop
    libhandy
    switchboard
  ];

  patches = [
    # VERSION in /etc/os-release is too long to display in swithboard
    # https://github.com/elementary/switchboard-plug-about/pull/222
    ./pretty-name.patch

    # The NixOS logo is not centered in the circular background.
    # Removing the background directly.
    ./remove-logo-background.patch
    (substituteAll {
      src = ./fix-paths.patch;
      appcenter = appcenter;
      elementary_feedback = elementary-feedback;
    })
  ];

  meta = with lib; {
    description = "Switchboard About Plug";
    homepage = "https://github.com/elementary/switchboard-plug-about";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
