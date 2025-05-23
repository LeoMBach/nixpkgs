{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "py-radix-sr";
  version = "1.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "SEKOIA-IO";
    repo = "py-radix";
    tag = "v${version}";
    hash = "sha256-HeXWHdPeW3m0FMtqyHhZGhgCc706Y2xiN8hn9MFt/RM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "name='py-radix'" "name='py-radix-sr'"

    substituteInPlace tests/test_{compat,regression}.py \
      --replace-fail assertEquals assertEqual \
      --replace-warn assertNotEquals assertNotEqual
  '';

  pythonImportsCheck = [ "radix" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # test does not complete on 3.12+
    "test_000_check_incref"
  ];

  meta = with lib; {
    description = "Python radix tree for IPv4 and IPv6 prefix matching";
    homepage = "https://github.com/SEKOIA-IO/py-radix";
    license = with licenses; [
      isc
      bsdOriginal
    ];
    teams = [ teams.wdz ];
  };
}
