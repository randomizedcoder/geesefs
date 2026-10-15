# Fix PR status

Tracks the small bug-fix PRs from the static-analysis and code-review work on
this branch. Each fix is on its own branch off `master`, changes one thing,
and comes with a table-driven test (positive, negative, boundary and corner
rows, each with a `description` and expected outcome). Every test was checked
to fail against the original code.

Workflow: draft PR in the fork first, then upstream once it has been reviewed.

- Fork: https://github.com/randomizedcoder/geesefs
- Upstream: https://github.com/yandex-cloud/geesefs

Last updated: 2026-10-14.

## Summary

| # | Branch | Fix | Fork PR | Upstream PR |
|---|---|---|---|---|
| 1 | `fix/gcp-iam-error-shadowing` | Report the real error when the GCP IAM metadata request fails | https://github.com/randomizedcoder/geesefs/pull/1 | https://github.com/yandex-cloud/geesefs/pull/215 |
| 2 | `fix/azure-prefer-full-key` | Prefer full-permission Azure account keys as intended | https://github.com/randomizedcoder/geesefs/pull/2 | https://github.com/yandex-cloud/geesefs/pull/216 |
| 3 | `fix/adlv2-lease-renew-leak` | Stop the ADLv2 lease renewal goroutine when signalled | https://github.com/randomizedcoder/geesefs/pull/3 | https://github.com/yandex-cloud/geesefs/pull/217 |
| 4 | `fix/cgroup-path-exists` | Use the per-cgroup memory directory when it exists | https://github.com/randomizedcoder/geesefs/pull/4 | not yet |
| 5 | `fix/pmetadata-key-lookup` | Keep metadata values whose keys are not lowercase | https://github.com/randomizedcoder/geesefs/pull/5 | not yet |
| 6 | `fix/s3-copy-threshold-units` | Default the S3 multipart copy threshold to 128 MiB, not 128 bytes | https://github.com/randomizedcoder/geesefs/pull/6 | not yet |
| 7 | `fix/v2signer-escaped-path` | Sign the escaped path for virtual-hosted V2 requests | https://github.com/randomizedcoder/geesefs/pull/7 | not yet |
| 8 | `fix/drop-group-before-user` | Drop the group before the user when giving up root | https://github.com/randomizedcoder/geesefs/pull/8 | not yet |
| 9 | `fix/help-flag` | Make --help print the help and exit successfully | https://github.com/randomizedcoder/geesefs/pull/9 | not yet |
| 10 | `fix/flusher-priority-index` | Check every lower priority for in-flight flushes in Flusher | https://github.com/randomizedcoder/geesefs/pull/10 | not yet |
| 11 | `fix/flush-fully-zero-parts` | Flush fully zero parts in step 3 of sendUploadParts | https://github.com/randomizedcoder/geesefs/pull/11 | not yet |
| 12 | `fix/flush-nil-etag` | Don't dereference a missing ETag after a flush | https://github.com/randomizedcoder/geesefs/pull/12 | not yet |
| 13 | `fix/cluster-to-errno` | Don't panic in toErrno on errors that are not an errno | https://github.com/randomizedcoder/geesefs/pull/13 | not yet |

## Upstream PRs (yandex-cloud/geesefs)

| PR | State | Fork PR |
|---|---|---|
| https://github.com/yandex-cloud/geesefs/pull/215 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/1 |
| https://github.com/yandex-cloud/geesefs/pull/216 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/2 |
| https://github.com/yandex-cloud/geesefs/pull/217 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/3 |

## Fork PRs (randomizedcoder/geesefs)

| PR | State | Area | Test |
|---|---|---|---|
| https://github.com/randomizedcoder/geesefs/pull/1 | draft, upstreamed | S3 / GCP IAM | `TestTryIAMErrors` |
| https://github.com/randomizedcoder/geesefs/pull/2 | draft, upstreamed | Azure config | `TestPickAccountKey` |
| https://github.com/randomizedcoder/geesefs/pull/3 | draft, upstreamed | ADLv2 | `TestRenewLeaseStops` |
| https://github.com/randomizedcoder/geesefs/pull/4 | draft, in review | cgroup memory limit | `TestMemoryCgroupDir` |
| https://github.com/randomizedcoder/geesefs/pull/5 | draft, in review | GCS / Azure metadata | `TestPMetadata` |
| https://github.com/randomizedcoder/geesefs/pull/6 | draft, in review | S3 config | `TestS3ConfigInitMultipartCopyThreshold` |
| https://github.com/randomizedcoder/geesefs/pull/7 | draft, in review | S3 V2 signer | `TestV2SignerCanonicalResource` |
| https://github.com/randomizedcoder/geesefs/pull/8 | draft, in review | main: privilege drop | `TestDropPrivileges` |
| https://github.com/randomizedcoder/geesefs/pull/9 | draft, in review | main: --help | `TestCheckArgs` |
| https://github.com/randomizedcoder/geesefs/pull/10 | draft, in review | flusher | `TestAnyFlushInFlight` |
| https://github.com/randomizedcoder/geesefs/pull/11 | draft, in review | flusher: zero parts | `TestZeroPartsToFlush` |
| https://github.com/randomizedcoder/geesefs/pull/12 | draft, in review | flush: missing ETag | `TestUpdateFromFlushETag` |
| https://github.com/randomizedcoder/geesefs/pull/13 | draft, in review | cluster gRPC | `TestToErrno` |

## Notes

- #8 and #9 both add `main_test.go`; whichever merges second needs a trivial
  conflict fix in that file.
- #3 follow-up: `MultipartBlobAbort` in `core/backend_adlv2.go` never signals
  `RenewLeaseStop`, so an aborted upload still renews its lease until the
  process exits.
- `GOOS=windows go vet ./core` fails on master (`undefined: NewGoofysFuse` in
  `core/goofys_test.go`); this is the `go-vet-windows` flake check failure and
  is not caused by any of these PRs.

## Candidates not yet raised

Found in code review, not yet verified in detail or turned into PRs.

| Where | Bug | Why not yet |
|---|---|---|
| `core/backend_azblob.go:240` | SAS token early-renewal condition can never be true (`Add(+buffer)` should be `Add(-buffer)`) | good next candidate |
| `core/backend_adlv2.go:103` | `X-Ms-Date` uses the host's local time zone instead of GMT | good next candidate |
| `core/buffer_list.go:801` | `mergeRA` can shrink a read-ahead range when merging | good next candidate |
| `core/utils.go:152` | `xattrEscape` escapes runes, not bytes, so binary values don't round-trip | fix is ~8 lines |
| `core/handles.go:996` | `DumpThis` builds gap maps but never appends them | debug output only |
| `core/cluster_fs.go:519` | `getInodeAttributes` locks `inode.mu` and calls `GetAttributes`, which locks it again (deadlock) | cluster mode |
| `core/cluster_fs.go:420` | `readDir` error path unlocks `dh.mu` twice (fatal error) | cluster mode |
| `core/cluster_fs.go:493` | `lookUpInode2` drops the RPC error and dereferences a nil response | cluster mode, needs a network test |
| `core/cluster_fs_fuse.go:797` | `SetInodeAttributes` passes the zeroed output attributes as inputs, truncating files on chmod/touch | cluster mode, ~15-line fix |
| `core/backend_s3.go:459` | `isAws` result discarded, so AWS 403s fall back to the V2 signer | may be intentional |
| `core/dir.go:359` | `markGapLoaded` drops the inserted gap | fixing it enables untested code that can panic |
| `core/goofys.go:255` | `abfs://container@account` bucket name is overwritten | inherited from goofys, unclear usage |
| `core/cfg/conf_azure.go:350` | stale lookup error returned even though a key is set | needs refactoring to test |
| `core/goofys_windows.go` | `Symlink` ignores errors; `Open` shadows `err` | Windows only, no hermetic test |
