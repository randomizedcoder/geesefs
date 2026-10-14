# nix/package.nix
#
# The geesefs binary for the build system, plus the release.yml cross-targets.
#
#   geesefs                  native linux build (buildGoModule), the default
#   geesefs-<target>         one release artifact, named as release.yml names it
#   geesefs-tests-linux-amd64  `go test -c ./core`, also published by release.yml
#   geesefs-release          every artifact above in one tree, for diffing
#                            against a GitHub release
#
# The cross builds are plain `go build` over the shared vendoredSource rather
# than buildGoModule with GOOS set: buildGoModule installs cross binaries into
# $GOPATH/bin/<goos>_<goarch>/ and runs its own checks for the build platform,
# while release.yml just wants one named file per target.
#
# Every build is CGO_ENABLED=0, matching the Makefile, Dockerfile.build and
# both workflows.
#
{
  pkgs,
  lib,
  src,
  vendoredSource,
}:

let
  versions = import ./versions.nix { inherit pkgs; };
  version = import ./lib/version.nix { inherit src; };

  ldflags = [
    "-s"
    "-w"
  ];

  geesefs = (pkgs.buildGoModule.override { inherit (versions) go; }) {
    pname = "geesefs";
    inherit version src ldflags;
    vendorHash = versions.goVendorHash;
    subPackages = [ "." ];
    env.CGO_ENABLED = "0";
    # The core tests need a live S3 endpoint (s3proxy) and FUSE; they run from
    # `make run-test`, not inside the Nix sandbox.
    doCheck = false;
    meta = {
      description = "FUSE filesystem over S3-compatible object storage";
      homepage = "https://github.com/yandex-cloud/geesefs";
      license = lib.licenses.asl20;
      mainProgram = "geesefs";
      platforms = lib.platforms.linux;
    };
  };

  # One `go build` per release target. `goCmd` is the go invocation after the
  # environment is set up, so the test binary can reuse the same scaffolding.
  mkCross =
    {
      name,
      goos,
      goarch,
      goCmd,
    }:
    pkgs.runCommand name
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
        export GOFLAGS=-mod=vendor
        export CGO_ENABLED=0 GOOS=${goos} GOARCH=${goarch}
        mkdir -p $out/bin
        ${goCmd}
      '';

  crossBinaries = lib.mapAttrs' (
    target: t:
    let
      name = "geesefs-${target}";
    in
    lib.nameValuePair name (mkCross {
      inherit name;
      inherit (t) goos goarch;
      goCmd = ''go build -trimpath -ldflags "${lib.concatStringsSep " " ldflags}" -o $out/bin/${name}${t.suffix} .'';
    })
  ) versions.releaseTargets;

  testsBinary = mkCross {
    name = "geesefs-tests-linux-amd64";
    goos = "linux";
    goarch = "amd64";
    goCmd = "go test -c -trimpath -o $out/bin/geesefs-tests-linux-amd64 ./core";
  };

  release = pkgs.symlinkJoin {
    name = "geesefs-release-${version}";
    paths = lib.attrValues crossBinaries ++ [ testsBinary ];
  };
in
crossBinaries
// {
  inherit geesefs;
  geesefs-tests-linux-amd64 = testsBinary;
  geesefs-release = release;
}
