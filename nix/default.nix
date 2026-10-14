# nix/default.nix
#
# Aggregator. Returns the per-system attribute set consumed by flake.nix.
#
{
  pkgs,
  lib,
  src,
}:

let
  versions = import ./versions.nix { inherit pkgs; };

  # Vendored source, used by every check that needs Go deps in the sandbox.
  inherit (import ./lib/goModules.nix { inherit pkgs src; }) vendoredSource;

  # geesefs, geesefs-<release target>, geesefs-tests-linux-amd64, geesefs-release.
  binaries = import ./package.nix {
    inherit
      pkgs
      lib
      src
      vendoredSource
      ;
  };

  # oci-geesefs, oci-geesefs-fuse.
  containers = import ./containers {
    inherit pkgs lib;
    inherit (binaries) geesefs;
  };

  lintTiers = import ./lint-tiers.nix { inherit pkgs; };

  # Needs network (it downloads the Go vulnerability database), so it cannot
  # be a sandboxed check. Run it as `nix run .#govulncheck`.
  govulncheck = pkgs.writeShellApplication {
    name = "govulncheck";
    runtimeInputs = [
      versions.go
      versions.govulncheck
    ];
    text = ''
      export CGO_ENABLED=0
      exec govulncheck ./... "$@"
    '';
  };

  mkApp = drv: {
    type = "app";
    program = lib.getExe drv;
  };
in
{
  packages = binaries // containers // { default = binaries.geesefs; };

  devShells.default = import ./devshell.nix { inherit pkgs; };

  checks = import ./checks {
    inherit
      pkgs
      lib
      src
      vendoredSource
      binaries
      containers
      ;
  };

  apps = {
    default = mkApp binaries.geesefs;
    govulncheck = mkApp govulncheck;
  }
  // lib.mapAttrs (_: mkApp) (lib.removeAttrs lintTiers [ "all" ]);
}
