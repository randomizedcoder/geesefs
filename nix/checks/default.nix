# nix/checks/default.nix
#
# Aggregates every `nix flake check` target for geesefs.
#
# Every attribute below is a flake-check target, all three golangci tiers
# included. To build one on its own, without the rest:
#   nix build .#checks.x86_64-linux.<name>
#
{
  pkgs,
  lib,
  src,
  vendoredSource,
  binaries,
  containers,
}:

{
  gofmt = import ./gofmt.nix { inherit pkgs src; };
  go-sec = import ./go-sec.nix { inherit pkgs vendoredSource; };

  nix-fmt = import ./nix-fmt.nix { inherit pkgs src; };
  deadnix = import ./deadnix.nix { inherit pkgs src; };
  statix = import ./statix.nix { inherit pkgs src; };
}
# go-vet, go-vet-windows, go-vet-darwin
// import ./go-vet.nix { inherit pkgs lib vendoredSource; }
# golangci-lint-quick, golangci-lint, golangci-lint-comprehensive
// import ./golangci-lint.nix { inherit pkgs lib vendoredSource; }
# geesefs-version, oci-geesefs, oci-geesefs-fuse
// import ./binary-smoke.nix {
  inherit pkgs lib containers;
  inherit (binaries) geesefs;
}
# Every release.yml artifact must keep building; today a broken darwin or
# windows build is only discovered when a `v*` tag is pushed.
// lib.filterAttrs (n: _: n != "geesefs") binaries
