# nix/checks/nix-fmt.nix
#
# `nixfmt --check` over every *.nix in the repo.
#
{
  pkgs,
  src,
}:

let
  versions = import ../versions.nix { inherit pkgs; };
in
pkgs.runCommand "geesefs-nix-fmt"
  {
    nativeBuildInputs = [
      versions.nixfmt
      pkgs.findutils
    ];
    inherit src;
  }
  ''
    cd $src
    mapfile -t files < <(find . -type f -name '*.nix' | sort)
    if ! nixfmt --check "''${files[@]}"; then
      echo "nixfmt: run 'nixfmt \$(git ls-files '*.nix')' to fix" >&2
      exit 1
    fi
    echo "nixfmt: ''${#files[@]} *.nix file(s) formatted" > $out
  ''
