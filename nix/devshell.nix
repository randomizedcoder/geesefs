# nix/devshell.nix
#
# Developer environment. `nix develop` lands here.
#
# Every contributor tool on PATH, the lint tier helpers from lint-tiers.nix,
# and a `geesefs-help` banner listing them.
#
{ pkgs }:

let
  versions = import ./versions.nix { inherit pkgs; };
  lintTiers = import ./lint-tiers.nix { inherit pkgs; };

  geesefsHelp = pkgs.writeShellApplication {
    name = "geesefs-help";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      cat <<'HELP'

      geesefs dev shell
      =================
      Build:
        go build                                Build ./geesefs
        nix build .#geesefs                     Nix build of the binary
        nix build .#geesefs-release             Every release.yml artifact
        nix build .#oci-geesefs                 OCI image (./result | docker load)

      Static analysis (fix issues, do not ignore):
        lint-quick                              Tier 0  (pre-commit)
        lint                                    Tier 1
        lint-comprehensive                      Tier 2
        lint-fix                                Apply Tier 1 auto-fixes
        lint-new                                Tier 1 on the diff since HEAD~1
        gosec ./...                             Security scan
        govulncheck ./...                       Known-vulnerability scan
                                                All lint-* run from the repo root.

      Tests (need s3proxy / FUSE, not run by Nix):
        make run-test
        make run-xfstests

      Nix:
        nix flake check                         Every check, all three tiers
        nix build .#checks.x86_64-linux.<name>  One check on its own

      HELP
    '';
  };
in
pkgs.mkShell {
  name = "geesefs-dev";

  packages = [
    versions.go
    versions.golangci-lint
    versions.gosec
    versions.govulncheck
    versions.deadnix
    versions.statix
    versions.nixfmt
    pkgs.gnumake
    pkgs.git
    pkgs.protobuf
    pkgs.protoc-gen-go
    pkgs.protoc-gen-go-grpc
    geesefsHelp
  ]
  ++ lintTiers.all;

  shellHook = ''
    export CGO_ENABLED=0
    geesefs-help
  '';
}
