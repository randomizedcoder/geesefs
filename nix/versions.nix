# nix/versions.nix
#
# Pinned tool versions for the geesefs Nix flake.
#
# Single source of truth — every other module reads from here.
# Changing a version here propagates to dev shell, build derivations, and checks.
#
{ pkgs }:

{
  # Go toolchain. go.mod says `go 1.25.9`, but nixpkgs removed go_1_25 as
  # end-of-life on 2026-09-14. A 1.26 toolchain builds a module that declares
  # 1.25 without complaint, so this is the closest pin nixpkgs can provide.
  go = pkgs.go_1_26;

  # Hash of the vendored module graph (nix/lib/goModules.nix). Must be updated
  # whenever go.mod / go.sum change. To refresh: set to pkgs.lib.fakeHash,
  # run `nix build .#geesefs`, and paste the `got:` value here.
  goVendorHash = "sha256-W43+b58WOf/djyZ/EEbgGGuA8+92KiNFoQexER0vBuY=";

  # Static analysis. deadnix (dead Nix bindings) and statix (Nix antipatterns)
  # lint the flake itself; the Go side gets golangci-lint and gosec.
  inherit (pkgs)
    golangci-lint
    gosec
    govulncheck
    deadnix
    statix
    ;
  inherit (pkgs) nixfmt;

  # Release targets, mirroring .github/workflows/release.yml one for one. The
  # attribute name is the release artifact name minus the `geesefs-` prefix.
  releaseTargets = {
    linux-amd64 = {
      goos = "linux";
      goarch = "amd64";
      suffix = "";
    };
    linux-arm64 = {
      goos = "linux";
      goarch = "arm64";
      suffix = "";
    };
    mac-amd64 = {
      goos = "darwin";
      goarch = "amd64";
      suffix = "";
    };
    mac-arm64 = {
      goos = "darwin";
      goarch = "arm64";
      suffix = "";
    };
    win-x64 = {
      goos = "windows";
      goarch = "amd64";
      suffix = ".exe";
    };
  };
}
