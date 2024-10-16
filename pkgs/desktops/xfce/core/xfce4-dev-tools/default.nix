{ lib
, mkXfceDerivation
, autoreconfHook
, libxslt
, docbook_xsl
, python3
, autoconf
, automake
, glib
, gtk-doc
, intltool
, libtool
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-dev-tools";
  version = "4.19.3";

  sha256 = "sha256-MiC6DYnhgLdp2+0xtTXnPWwvwbgj6N1l/Aah+HJSTL8=";

  nativeBuildInputs = [
    autoreconfHook
    libxslt
    docbook_xsl
  ];

  buildInputs = [
    python3 # for xdt-gen-visibility
  ];

  propagatedBuildInputs = [
    autoconf
    automake
    glib
    gtk-doc
    intltool
    libtool
  ];

  postPatch = ''
    # Do not require meson, which is only used in xfce-do-release.
    substituteInPlace configure.ac --replace-fail "AC_MSG_ERROR([meson missing])" ""

    # Pointing datarootdir to $dev will result in cyclic dependency.
    # Simply drop it since we already set ACLOCAL_PATH ourselves.
    substituteInPlace scripts/xdt-autogen.in \
      --replace-fail "export ACLOCAL_FLAGS" "# export ACLOCAL_FLAGS"
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Autoconf macros and scripts to augment app build systems";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
