{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  gtk3,
  python3,
  wrapGAppsHook3,
  gnupg,
  file-roller,
}:

let
  pythonEnv = python3.withPackages (
    pp: with pp; [
      pygobject3
      gpg
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nemo-seahorse";
  version = "6.8.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    tag = finalAttrs.version;
    hash = "sha256-dadQnR6YNm6rC6qT0MGssSXu37ST1kZQVGIupB0nA7Q=";
  };

  sourceRoot = "${finalAttrs.src.name}/nemo-seahorse";

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    pythonEnv
  ];

  postPatch = ''
    substituteInPlace tool/nemo-seahorse-tool \
      --replace-fail "#!/usr/bin/python3" "#!${pythonEnv}/bin/python3"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${
        lib.makeBinPath [
          gnupg
          file-roller
        ]
      }"
    )
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = {
    homepage = "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-seahorse";
    changelog = "https://github.com/linuxmint/nemo-extensions/blob/master/nemo-seahorse/ChangeLog";
    description = "Nemo seahorse extension";
    longDescription = ''
      You can add the extension to nemo using the following configuration:
      ```nix
      {
        environment.systemPackages = with pkgs; [
          (nemo-with-extensions.override {
            extensions = [ nemo-seahorse ];
          })
        ];
      }
      ```
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
