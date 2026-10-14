# nix/checks/binary-smoke.nix
#
# Cheap runtime checks on the built artifacts:
#
#   geesefs-version  the native binary runs, and `--version` reports the
#                    GEESEFS_VERSION the package was named after.
#   oci-<image>      each image tarball contains the binary and the CA bundle
#                    — the two things Dockerfile.build's scratch image lacks
#                    one of.
#
{
  pkgs,
  lib,
  geesefs,
  containers,
}:

let
  imageCheck =
    name: image:
    pkgs.runCommand "geesefs-check-${name}"
      {
        nativeBuildInputs = [
          pkgs.gnutar
          pkgs.jq
        ];
      }
      ''
        mkdir img && ${image} | tar -x -C img
        listing=$(jq -r '.[0].Layers[]' img/manifest.json \
          | while read -r layer; do tar -tf "img/$layer"; done \
          | sed -e 's|^\./||' -e 's|^/||')
        for want in '${lib.removePrefix "/" (lib.getExe geesefs)}' \
                    'etc/ssl/certs/ca-certificates.crt'; do
          if ! grep -qxF "$want" <<<"$listing"; then
            echo "${name}: image is missing $want" >&2
            exit 1
          fi
        done
        echo "${name}: binary and CA bundle present" > $out
      '';
in
{
  geesefs-version = pkgs.runCommand "geesefs-check-version" { } ''
    out_v=$(${lib.getExe geesefs} --version 2>&1)
    echo "$out_v"
    if ! grep -qF '${geesefs.version}' <<<"$out_v"; then
      echo "geesefs --version did not report ${geesefs.version}" >&2
      exit 1
    fi
    echo "$out_v" > $out
  '';
}
// lib.mapAttrs imageCheck containers
