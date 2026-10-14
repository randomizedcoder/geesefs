# nix/checks/gofmt.nix
#
# `gofmt -l .` — fails on any unformatted file. Same command as the `lint` job
# in .github/workflows/test.yml, minus generated protobuf code.
#
{
  pkgs,
  src,
}:

let
  versions = import ../versions.nix { inherit pkgs; };
in
pkgs.runCommand "geesefs-gofmt"
  {
    nativeBuildInputs = [ versions.go ];
    inherit src;
  }
  ''
    cd $src
    unformatted=$(gofmt -l . 2>&1 | grep -v -E '\.pb\.go$' || true)
    if [ -n "$unformatted" ]; then
      echo "gofmt: the following files are not formatted:" >&2
      echo "$unformatted" >&2
      exit 1
    fi
    echo "gofmt: all files formatted" > $out
  ''
