# nix/lint-tiers.nix
#
# The golangci-lint tier helpers as writeShellApplication packages, shared by
# the dev shell and the flake's `apps` so the two cannot drift. Being
# writeShellApplication, their bash is shellcheck'd at build time.
#
# Named for the command the user types (`lint-quick`, not `geesefs-lint-quick`).
#
# No --timeout on any invocation: each tier config sets `run.timeout`, and a
# CLI --timeout silently overrides it.
#
# Outside the sandbox these use the normal module cache (no vendor/ tree is
# committed), so the first run downloads dependencies.
#
{ pkgs }:

let
  versions = import ./versions.nix { inherit pkgs; };

  # Every tier passes a relative --config path and `./...`, so they must run
  # from the repo root; as PATH binaries they can be invoked from anywhere.
  mkTier =
    {
      name,
      config,
      extraArgs ? [ ],
      extraInputs ? [ ],
    }:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [
        versions.go
        versions.golangci-lint
      ]
      ++ extraInputs;
      text = ''
        if [ ! -f flake.nix ] || [ ! -f go.mod ]; then
          echo "${name}: must be run from the geesefs repo root" >&2
          exit 2
        fi
        export CGO_ENABLED=0
        exec golangci-lint run --config ${config} ${pkgs.lib.concatStringsSep " " extraArgs} ./... "$@"
      '';
    };
in
rec {
  # Tier 0 — fast feedback, pre-commit.
  lint-quick = mkTier {
    name = "lint-quick";
    config = ".golangci-quick.yml";
  };

  # Tier 1 — the main gating tier.
  lint = mkTier {
    name = "lint";
    config = ".golangci.yml";
  };

  # Tier 2 — comprehensive.
  lint-comprehensive = mkTier {
    name = "lint-comprehensive";
    config = ".golangci-comprehensive.yml";
  };

  # Tier 1 with --fix. Deliberately the Tier 1 config: auto-fixes land only
  # for findings that tier would block on anyway.
  lint-fix = mkTier {
    name = "lint-fix";
    config = ".golangci.yml";
    extraArgs = [ "--fix" ];
  };

  # Tier 1 restricted to the diff since HEAD~1. golangci-lint shells out to
  # git to resolve --new-from-rev.
  lint-new = mkTier {
    name = "lint-new";
    config = ".golangci.yml";
    extraArgs = [ "--new-from-rev=HEAD~1" ];
    extraInputs = [ pkgs.git ];
  };

  all = [
    lint-quick
    lint
    lint-comprehensive
    lint-fix
    lint-new
  ];
}
