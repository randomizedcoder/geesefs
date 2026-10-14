# nix/lib/goModules.nix
#
# Produces the geesefs Go module dependencies as a vendor/ tree, plus a
# writable copy of the source with that tree already in place. Reused by every
# check that needs Go deps inside the (offline) Nix sandbox.
#
# The vendor hash lives in nix/versions.nix (`goVendorHash`); see the comment
# there for how to refresh it after a go.mod / go.sum change.
#
# go.mod's two `replace` directives (cgofuse, fusego) point at other module
# paths, not local directories, so they vendor like any other dependency.
#
{
  pkgs,
  src,
}:

let
  versions = import ../versions.nix { inherit pkgs; };

  # No `subPackages` restriction: lint and vet type-check every package in the
  # module (bench/ and test/ included), so vendor/ must hold the full graph.
  parent = (pkgs.buildGoModule.override { inherit (versions) go; }) {
    pname = "geesefs";
    version = "vendored";
    inherit src;
    vendorHash = versions.goVendorHash;
    env.CGO_ENABLED = "0";
    doCheck = false;
  };
in
{
  inherit (parent) goModules;
  vendoredSource = pkgs.runCommand "geesefs-vendored-source" { } ''
    cp -r ${src}/. $out
    chmod -R +w $out
    cp -r ${parent.goModules} $out/vendor
  '';
}
