{ mkDerivation
, extra-cmake-modules
, gettext
, kdoctools
, python3
, appstream-qt
, discount
, flatpak
, fwupd
, ostree
, pcre
, util-linux
, qtquickcontrols2
, qtwebview
, qtx11extras
, karchive
, kcmutils
, kconfig
, kcrash
, kdbusaddons
, kdeclarative
, kidletime
, kio
, kirigami2
, kitemmodels
, knewstuff
, kpurpose
, kuserfeedback
, kwindowsystem
, kxmlgui
, plasma-framework
, fetchpatch}:

mkDerivation {
  pname = "discover";

  patches = [
    # patch to fix build with Appstream 1.0
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/discover/-/raw/main/appstream-1.0.patch";
      hash = "sha256-uDRgdCfu79bwitFedVHoa47pM8XYWblrvn3EjEDnJoU=";
    })
  ];

  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools python3 ];
  buildInputs = [
    # discount is needed for libmarkdown
    appstream-qt
    discount
    flatpak
    fwupd
    ostree
    pcre
    util-linux
    qtquickcontrols2
    qtwebview
    qtx11extras
    karchive
    kcmutils
    kconfig
    kcrash
    kdbusaddons
    kdeclarative
    kidletime
    kio
    kirigami2
    kitemmodels
    knewstuff
    kpurpose
    kuserfeedback
    kwindowsystem
    kxmlgui
    plasma-framework
  ];
}
