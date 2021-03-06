{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-xdist
, pythonOlder
, matplotlib
, mock
, pytorch
, pynvml
, scikit-learn
, tqdm
}:

buildPythonPackage rec {
  pname = "ignite";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = pname;
    rev = "v${version}";
    sha256 = "057v8v5p2picmgiidr9lzjbh7nj54pv95m6lyya3y7dw4vzaamij";
  };

  checkInputs = [ pytestCheckHook matplotlib mock pytest-xdist ];
  propagatedBuildInputs = [ pytorch scikit-learn tqdm pynvml ];

  # runs succesfully in 3.9, however, async isn't correctly closed so it will fail after test suite.
  doCheck = pythonOlder "3.9";

  # Some packages are not in NixPkgs; other tests try to build distributed
  # models, which doesn't work in the sandbox.
  # avoid tests which need special packages
  pytestFlagsArray = [
    "--ignore=tests/ignite/contrib/handlers/test_trains_logger.py"
    "--ignore=tests/ignite/metrics/test_dill.py"
    "--ignore=tests/ignite/metrics/test_ssim.py"
    "tests/"
  ];

  # disable tests which need specific packages
  disabledTests = [
    "idist"
    "tensorboard"
    "mlflow"
    "trains"
    "visdom"
    "test_setup_neptune"
    "test_output_handler" # needs mlflow
    "test_integration"
    "test_pbar" # slight output differences
    "test_write_results"
    "test_setup_plx"
  ];

  meta = with lib; {
    description = "High-level training library for PyTorch";
    homepage = "https://pytorch.org/ignite";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
