{
  stdenv,
  lib,
  wrapGAppsHook3,
  folder-color-switcher,
  nemo,
  nemo-emblems,
  nemo-fileroller,
  nemo-python,
  python3,
  xapp,
  xorg,
  extensions ? [ ],
  useDefaultExtensions ? true,
}:

let
  selectedExtensions =
    extensions
    ++ lib.optionals useDefaultExtensions [
      # We keep this in sync with a default Mint installation
      # Right now (only) nemo-share is missing
      folder-color-switcher
      nemo-emblems
      nemo-fileroller
      nemo-python
    ];
  nemoPythonExtensionsDeps = lib.concatMap (x: x.nemoPythonExtensionDeps or [ ]) selectedExtensions;

  nemo-unwrapped = nemo.override { withWrapper = false; };
in
stdenv.mkDerivation {
  pname = "nemo-with-extensions";
  inherit (nemo-unwrapped) version;

  src = null;

  paths = [ nemo-unwrapped ] ++ selectedExtensions;

  passAsFile = [ "paths" ];

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs =
    nemo-unwrapped.buildInputs ++ lib.concatMap (x: x.buildInputs or [ ]) selectedExtensions;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  preferLocalBuild = true;
  allowSubstitutes = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    for i in $(cat $pathsPath); do
      ${xorg.lndir}/bin/lndir -silent $i $out
    done

    runHook postInstall
  '';

  postInstall = ''
    # Point to wrapped binary in all service files
    for file in "share/dbus-1/services/nemo.FileManager1.service" \
      "share/dbus-1/services/nemo.service"
    do
      rm "$out/$file"
      substitute "${nemo-unwrapped}/$file" "$out/$file" \
        --replace-fail "${nemo-unwrapped}" "$out"
    done
  '';

  # We only want to wrap executables from nemo-unwrapped.
  dontWrapGApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --set "NEMO_EXTENSION_DIR" "$out/${nemo.extensiondir}" \
      --set "NEMO_ACTION_DIR" "$out/share/nemo/actions" \
      --set "NEMO_PYTHON_EXTENSION_DIR" "$out/share/nemo-python/extensions" \
      --set "NEMO_PYTHON_SEARCH_PATH" "${python3.pkgs.makePythonPath nemoPythonExtensionsDeps}"
      --prefix XDG_DATA_DIRS : "${xapp}/share"
    )
  '';

  postFixup = ''
    for f in $(ls -1 ${nemo-unwrapped}/bin); do
      wrapGApp "$out/bin/$f"
    done
    for f in $(ls -1 ${nemo-unwrapped}/libexec); do
      wrapGApp "$out/libexec/$f"
    done
  '';

  meta = builtins.removeAttrs nemo-unwrapped.meta [
    "name"
    "outputsToInstall"
    "position"
  ];
}
