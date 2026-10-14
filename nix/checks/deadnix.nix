# nix/checks/deadnix.nix
#
# `deadnix` over every *.nix in the repo — unused lambda arguments, unused
# `let` bindings, dead `with` scopes.
#
# Not auto-fixed in CI on purpose: `deadnix --edit` rewrites a lambda pattern
# but not its call sites, so dropping an argument from a pattern without `...`
# turns every `import ./foo.nix { inherit … }` into an "unexpected argument"
# eval error. Fix by hand, or prefix a required-but-unused argument with `_`.
#
{
  pkgs,
  src,
}:

let
  versions = import ../versions.nix { inherit pkgs; };
in
pkgs.runCommand "geesefs-deadnix"
  {
    nativeBuildInputs = [
      versions.deadnix
      pkgs.findutils
    ];
    inherit src;
  }
  ''
    cd $src
    mapfile -t files < <(find . -type f -name '*.nix' | sort)
    # --fail turns findings into a non-zero exit; without it deadnix reports
    # and still succeeds.
    deadnix --fail "''${files[@]}"
    echo "deadnix: no dead code in ''${#files[@]} *.nix file(s)" > $out
  ''
