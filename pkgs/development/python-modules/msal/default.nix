{ buildPythonPackage
, fetchPypi
, lib

# pythonPackages
, pyjwt
, requests
}:

buildPythonPackage rec {
  pname = "msal";
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5cc93f09523c703d4e00a901cf719ade4faf2c3d14961ba52060ae78d5b25327";
  };

  propagatedBuildInputs = [
    pyjwt
    requests
  ];

  # Tests assume Network Connectivity:
  # https://github.com/AzureAD/microsoft-authentication-library-for-python/blob/e2958961e8ec16d0af4199f60c36c3f913497e48/tests/test_authority.py#L73
  doCheck = false;

  pythonImportsCheck = [ "msal" ];

  meta = with lib; {
    description = "The Microsoft Authentication Library (MSAL) for Python library enables your app to access the Microsoft Cloud by supporting authentication of users with Microsoft Azure Active Directory accounts (AAD) and Microsoft Accounts (MSA) using industry standard OAuth2 and OpenID Connect";
    homepage = "https://github.com/AzureAD/microsoft-authentication-library-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
