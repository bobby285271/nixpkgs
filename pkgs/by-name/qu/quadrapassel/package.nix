{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gtk4,
  libadwaita,
  libgee,
  pango,
  gnome,
  gdk-pixbuf,
  librsvg,
  gsound,
  libmanette,
  blueprint-compiler,
  wrapGAppsHook4,
  meson,
  ninja,
  vala,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quadrapassel";
  version = "50.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/quadrapassel/${lib.versions.major finalAttrs.version}/quadrapassel-${finalAttrs.version}.tar.xz";
    hash = "sha256-Rfsoct+OIPFzLOWQVl5w4jkOcUv6rxfoAzVAr0pVG6c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    desktop-file-utils
    pkg-config
    blueprint-compiler
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libgee
    pango
    gdk-pixbuf
    librsvg
    libmanette
    gsound
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "quadrapassel";
    };
  };

  meta = {
    description = "Classic falling-block game, Tetris";
    mainProgram = "quadrapassel";
    homepage = "https://gitlab.gnome.org/GNOME/quadrapassel";
    changelog = "https://gitlab.gnome.org/GNOME/quadrapassel/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})
