{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, gi-docgen
, meson
, ninja
, pkg-config
, sassc
, vala
, gobject-introspection
, appstream
, fribidi
, glib
, gtk4
, gnome
, gsettings-desktop-schemas
, xvfb-run
, AppKit
, Foundation
}:

stdenv.mkDerivation rec {
  pname = "libadwaita";
  version = "1.4.2";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # demo app

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libadwaita";
    rev = version;
    hash = "sha256-SsQbCnNtgiRWMZerEjSSw+CU5m6bGRv8ILY/TITGtL4=";
  };

  patches = [
    # Fix building against libappstream 1.0
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libadwaita/-/commit/c579fbe0c10d2b761cfe1fe4e825aaa19fe81c77.patch";
      hash = "sha256-mi1mB0xVC1mIYFrpGoxLQb3pQjHbKQ1XZ6PCUi1rahY=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libadwaita/-/commit/3e3967d5f69180644519936991cad10136e84ca9.patch";
      hash = "sha256-AZoltE8YRDMHNbcXBKuJ5LNSUR7SFJC1GkbllvIjPUY=";
    })
    # fix "Validate appstream file" test
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libadwaita/-/commit/282b2a3445296da98b7e438d938bdcf590e00d3f.patch";
      hash = "sha256-SiS+cab7L+ibgn6DbqLC0DvgRBzgnjpHEcu+VqPkBtw=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gi-docgen
    meson
    ninja
    pkg-config
    sassc
    vala
    gobject-introspection
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ] ++ lib.optionals (!doCheck) [
    "-Dtests=false"
  ];

  buildInputs = [
    appstream
    fribidi
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Foundation
  ];

  propagatedBuildInputs = [
    gtk4
  ];

  nativeCheckInputs = [
    gnome.adwaita-icon-theme
  ] ++ lib.optionals (!stdenv.isDarwin) [
    xvfb-run
  ];

  # Tests had to be disabled on Darwin because test-button-content fails
  #
  # not ok /Adwaita/ButtonContent/style_class_button - Gdk-FATAL-CRITICAL:
  # gdk_macos_monitor_get_workarea: assertion 'GDK_IS_MACOS_MONITOR (self)' failed
  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    runHook preCheck

    testEnvironment=(
      # Disable portal since we cannot run it in tests.
      ADW_DISABLE_PORTAL=1

      # AdwSettings needs to be initialized from “org.gnome.desktop.interface” GSettings schema when portal is not used for color scheme.
      # It will not actually be used since the “color-scheme” key will only have been introduced in GNOME 42, falling back to detecting theme name.
      # See adw_settings_constructed function in https://gitlab.gnome.org/GNOME/libadwaita/commit/60ec69f0a5d49cad8a6d79e4ecefd06dc6e3db12
      "XDG_DATA_DIRS=${glib.getSchemaDataDirPath gsettings-desktop-schemas}"

      # Tests need a cache directory
      "HOME=$TMPDIR"
    )
    env "''${testEnvironment[@]}" ${lib.optionalString (!stdenv.isDarwin) "xvfb-run"} \
      meson test --print-errorlogs

    runHook postCheck
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    changelog = "https://gitlab.gnome.org/GNOME/libadwaita/-/blob/${src.rev}/NEWS";
    description = "Library to help with developing UI for mobile devices using GTK/GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/libadwaita";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ dotlambda ]);
    platforms = platforms.unix;
  };
}
