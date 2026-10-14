# nix/checks/statix.nix
#
# `statix check` over every *.nix in the repo — Nix antipatterns (manual
# inherit, useless parens, redundant `rec`, …). Companion to deadnix.nix:
# deadnix finds what is unused, statix finds what is written the long way.
#
# Lint scope lives in the repo-root statix.toml. Findings are fixed, not
# silenced with `# statix: ignore`.
#
{
  pkgs,
  src,
}:

let
  versions = import ../versions.nix { inherit pkgs; };
in
pkgs.runCommand "geesefs-statix"
  {
    nativeBuildInputs = [ versions.statix ];
    inherit src;
  }
  ''
    cd $src
    statix check -o errfmt .
    echo "statix: no antipatterns" > $out
  ''
