# nix/checks/go-vet.nix
#
# `go vet ./...` against the vendored source tree, once per GOOS.
#
# geesefs has build-tagged files (main_windows.go, main_nowindows.go, the
# `!windows && !linux` and `(!linux || !arm64) && !windows` files in core/), so
# a linux-only vet never type-checks the windows and darwin variants. The
# release workflow builds all three, so all three are vetted here.
#
{
  pkgs,
  lib,
  vendoredSource,
}:

let
  versions = import ../versions.nix { inherit pkgs; };

  mkVet =
    goos:
    pkgs.runCommand "geesefs-go-vet-${goos}"
      {
        nativeBuildInputs = [ versions.go ];
        inherit vendoredSource;
      }
      ''
        cp -r $vendoredSource ./geesefs && chmod -R +w ./geesefs
        cd ./geesefs
        export HOME=$(mktemp -d)
        export GOCACHE=$HOME/go-build
        export GOPROXY=off
        export CGO_ENABLED=0
        export GOOS=${goos}
        export GOFLAGS=-mod=vendor
        go vet ./... > $out 2>&1 || (cat $out && exit 1)
      '';
in
{
  go-vet = mkVet "linux";
}
// lib.genAttrs [ "go-vet-windows" "go-vet-darwin" ] (n: mkVet (lib.removePrefix "go-vet-" n))
