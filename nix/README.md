# nix/

Nix build, image and static-analysis setup for geesefs. `flake.nix` at the repo
root is a thin orchestrator; everything lives here.

| File | What it does |
|---|---|
| `default.nix` | Aggregator: returns `packages`, `devShells`, `checks`, `apps` |
| `versions.nix` | Every pinned tool, the Go vendor hash, the release targets |
| `package.nix` | `geesefs`, the release.yml cross-targets, `geesefs-release` |
| `containers/` | `oci-geesefs`, `oci-geesefs-fuse` |
| `devshell.nix` | `nix develop` |
| `lint-tiers.nix` | `lint-quick`, `lint`, `lint-comprehensive`, `lint-fix`, `lint-new` |
| `lib/goModules.nix` | Vendored module tree for sandboxed checks |
| `lib/version.nix` | Reads `GEESEFS_VERSION` from `core/cfg/flags.go` |
| `checks/` | One file per `nix flake check` target |

## Packages

```sh
nix build .#geesefs                    # native linux binary (default)
nix build .#geesefs-linux-arm64        # any release.yml artifact by name:
                                       #   linux-amd64 linux-arm64 mac-amd64
                                       #   mac-arm64 win-x64 tests-linux-amd64
nix build .#geesefs-release            # all of them in one tree
nix build .#oci-geesefs && ./result | docker load
nix build .#oci-geesefs-fuse && ./result | docker load
```

Both images carry a CA bundle, which `Dockerfile.build`'s scratch image does
not. `oci-geesefs-fuse` adds `fusermount3` for unprivileged mounts; see the
header of `containers/default.nix`.

## Checks

`nix flake check` builds all of them. Build one alone with
`nix build .#checks.x86_64-linux.<name>`; read a failure with
`nix log .#checks.x86_64-linux.<name>`.

| Check | What |
|---|---|
| `gofmt` | `gofmt -l`, generated `*.pb.go` excluded |
| `go-vet`, `go-vet-windows`, `go-vet-darwin` | `go vet ./...` per GOOS, so build-tagged files are covered |
| `golangci-lint-quick` | Tier 0, `.golangci-quick.yml` |
| `golangci-lint` | Tier 1, `.golangci.yml` |
| `golangci-lint-comprehensive` | Tier 2, `.golangci-comprehensive.yml` |
| `go-sec` | gosec, full rule set |
| `nix-fmt`, `deadnix`, `statix` | Lint the Nix files themselves |
| `geesefs-version` | Binary runs and reports `GEESEFS_VERSION` |
| `oci-geesefs`, `oci-geesefs-fuse` | Image contains the binary and the CA bundle |
| `geesefs-<target>`, `geesefs-release` | Every release artifact still builds |

`govulncheck` needs network for its vulnerability database, so it is an app
rather than a check: `nix run .#govulncheck`.

## Updating the vendor hash

After any `go.mod` / `go.sum` change, set `goVendorHash` in `versions.nix` to
`pkgs.lib.fakeHash`, run `nix build .#geesefs`, and paste the `got:` hash.
