# nix/checks/go-sec.nix
#
# Security scan via gosec, separate from the gosec linter inside Tier 1 so it
# runs gosec's full rule set with its own exclusion list.
#
# Exclusions (each one is justified in-place):
#   (none yet)
#
{
  pkgs,
  vendoredSource,
}:

let
  versions = import ../versions.nix { inherit pkgs; };
in
pkgs.runCommand "geesefs-gosec"
  {
    nativeBuildInputs = [
      versions.go
      versions.gosec
    ];
    inherit vendoredSource;
  }
  ''
    cp -r $vendoredSource ./geesefs && chmod -R +w ./geesefs
    cd ./geesefs
    export HOME=$(mktemp -d)
    export GOCACHE=$HOME/go-build
    export GOPROXY=off
    export CGO_ENABLED=0
    export GOFLAGS=-mod=vendor
    gosec -exclude-generated -exclude-dir=vendor -fmt=text ./... > $out 2>&1 || {
      rc=$?
      cat $out
      exit "$rc"
    }
  ''
