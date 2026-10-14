#
# flake.nix — geesefs
#
# Thin orchestrator. Every concern lives under ./nix/ and is wired up here.
# See ./nix/default.nix for the per-system aggregator and ./nix/README.md for
# the full target list.
#
# Quick references:
#   nix develop                          # dev shell (Go, golangci-lint, gosec, …)
#   nix build .#geesefs                  # linux binary for this system
#   nix build .#geesefs-release          # every release.yml target in one tree
#   nix build .#oci-geesefs              # OCI image (load via `./result | docker load`)
#   nix build .#oci-geesefs-fuse         # same, plus fusermount3 for non-root mounts
#   nix flake check                      # every static-analysis check below
#   nix build .#checks.x86_64-linux.golangci-lint   # one check on its own
#   nix run    .#govulncheck             # vulnerability scan (needs network)
#
# Static analysis (all in `nix flake check`):
#   gofmt, go-vet, go-vet-cross (windows/darwin build tags),
#   golangci-lint-quick (Tier 0), golangci-lint (Tier 1),
#   golangci-lint-comprehensive (Tier 2), go-sec,
#   nix-fmt, deadnix, statix,
#   plus build checks: every release cross-target and the OCI images.
#
{
  description = "geesefs — FUSE filesystem over S3-compatible object storage";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (nixpkgs) lib;

        aggregator = import ./nix {
          inherit pkgs lib;
          src = lib.cleanSource ./.;
        };
      in
      {
        inherit (aggregator)
          packages
          devShells
          checks
          apps
          ;
      }
    );
}
