# nix/checks/golangci-lint.nix
#
# The three golangci-lint tiers, one check each:
#
#   golangci-lint-quick          Tier 0  .golangci-quick.yml
#   golangci-lint                Tier 1  .golangci.yml
#   golangci-lint-comprehensive  Tier 2  .golangci-comprehensive.yml
#
# Each tier's linter set is a superset of the one below it; the configs say
# which linters each adds.
#
# No --timeout here. Each config sets `run.timeout`, and a CLI --timeout
# silently overrides it.
#
{
  pkgs,
  lib,
  vendoredSource,
}:

let
  versions = import ../versions.nix { inherit pkgs; };

  mkTier =
    name: config:
    pkgs.runCommand "geesefs-${name}"
      {
        nativeBuildInputs = [
          versions.go
          versions.golangci-lint
        ];
        inherit vendoredSource;
      }
      ''
        cp -r $vendoredSource ./geesefs && chmod -R +w ./geesefs
        cd ./geesefs
        export HOME=$(mktemp -d)
        export GOCACHE=$HOME/go-build
        export GOLANGCI_LINT_CACHE=$HOME/golangci
        export GOPROXY=off
        export CGO_ENABLED=0
        export GOFLAGS=-mod=vendor
        golangci-lint run --config ${config} ./... > $out 2>&1 \
          || (cat $out && exit 1)
      '';
in
lib.mapAttrs mkTier {
  golangci-lint-quick = ".golangci-quick.yml";
  golangci-lint = ".golangci.yml";
  golangci-lint-comprehensive = ".golangci-comprehensive.yml";
}
