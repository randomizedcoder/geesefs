# nix/containers/default.nix
#
# OCI images. The Nix counterpart of Dockerfile.build's `final` stage.
#
#   oci-geesefs       geesefs + CA bundle. Mounting needs root or
#                     CAP_SYS_ADMIN plus /dev/fuse (`docker run --device
#                     /dev/fuse --cap-add SYS_ADMIN …`): the fuse library
#                     (vitalif/fusego, mount_linux.go) mounts directly when it
#                     can and only falls back to fusermount otherwise.
#   oci-geesefs-fuse  the same plus fuse3, so the fusermount3 fallback exists
#                     when the process is not privileged enough to mount
#                     directly.
#
# Both are streamLayeredImage outputs: `result` is a script that writes the
# image tarball to stdout, so load with `./result | docker load`.
#
# Difference from Dockerfile.build, on purpose: that image is FROM scratch with
# only /geesefs in it, so it has no CA certificates and Go's crypto/x509 has no
# roots to verify HTTPS endpoints against. These images ship
# dockerTools.caCertificates and point SSL_CERT_FILE at it.
#
{
  pkgs,
  lib,
  geesefs,
}:

let
  mkImage =
    {
      name,
      extraContents ? [ ],
    }:
    pkgs.dockerTools.streamLayeredImage {
      inherit name;
      tag = geesefs.version;
      contents = [
        geesefs
        pkgs.dockerTools.caCertificates
      ]
      ++ extraContents;
      config = {
        Entrypoint = [ (lib.getExe geesefs) ];
        Env = [
          "SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt"
          "PATH=/bin"
        ];
      };
    };
in
{
  oci-geesefs = mkImage { name = "geesefs"; };
  oci-geesefs-fuse = mkImage {
    name = "geesefs-fuse";
    extraContents = [ pkgs.fuse3 ];
  };
}
