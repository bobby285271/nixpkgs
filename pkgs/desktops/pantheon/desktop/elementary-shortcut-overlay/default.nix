{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, meson
, ninja
, vala
, libxml2
, desktop-file-utils
, gtk3
, glib
, granite
, libgee
, libhandy
, elementary-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-shortcut-overlay";
  version = "1.2.0";

  repoName = "shortcut-overlay";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1zs2fpx4agr00rsfmpi00nhiw92mlypzm4p9x3g851p24m62fn79";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    libxml2
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    glib
    granite
    gtk3
    libgee
    libhandy
  ];

  meta = with lib; {
    description = "A native OS-wide shortcut overlay to be launched by Gala";
    homepage = "https://github.com/elementary/shortcut-overlay";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
