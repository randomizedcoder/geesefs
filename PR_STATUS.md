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
| 4 | `fix/cgroup-path-exists` | Use the per-cgroup memory directory when it exists | https://github.com/randomizedcoder/geesefs/pull/4 | https://github.com/yandex-cloud/geesefs/pull/218 |
| 5 | `fix/pmetadata-key-lookup` | Keep metadata values whose keys are not lowercase | https://github.com/randomizedcoder/geesefs/pull/5 | https://github.com/yandex-cloud/geesefs/pull/219 |
| 6 | `fix/s3-copy-threshold-units` | Default the S3 multipart copy threshold to 128 MiB, not 128 bytes | https://github.com/randomizedcoder/geesefs/pull/6 | https://github.com/yandex-cloud/geesefs/pull/220 |
| 7 | `fix/v2signer-escaped-path` | Sign the escaped path for virtual-hosted V2 requests | https://github.com/randomizedcoder/geesefs/pull/7 | https://github.com/yandex-cloud/geesefs/pull/221 |
| 8 | `fix/drop-group-before-user` | Drop the group before the user when giving up root | https://github.com/randomizedcoder/geesefs/pull/8 | https://github.com/yandex-cloud/geesefs/pull/222 |
| 9 | `fix/help-flag` | Make --help print the help and exit successfully | https://github.com/randomizedcoder/geesefs/pull/9 | https://github.com/yandex-cloud/geesefs/pull/223 |
| 10 | `fix/flusher-priority-index` | Check every lower priority for in-flight flushes in Flusher | https://github.com/randomizedcoder/geesefs/pull/10 | https://github.com/yandex-cloud/geesefs/pull/224 |
| 11 | `fix/flush-fully-zero-parts` | Flush fully zero parts in step 3 of sendUploadParts | https://github.com/randomizedcoder/geesefs/pull/11 | https://github.com/yandex-cloud/geesefs/pull/225 |
| 12 | `fix/flush-nil-etag` | Don't dereference a missing ETag after a flush | https://github.com/randomizedcoder/geesefs/pull/12 | https://github.com/yandex-cloud/geesefs/pull/226 |
| 13 | `fix/cluster-to-errno` | Don't panic in toErrno on errors that are not an errno | https://github.com/randomizedcoder/geesefs/pull/13 | https://github.com/yandex-cloud/geesefs/pull/227 |
| 14 | `fix/race-gcs-delete-blobs` | Fix data race on the error in GCS3.DeleteBlobs | https://github.com/randomizedcoder/geesefs/pull/14 | https://github.com/yandex-cloud/geesefs/pull/228 |
| 15 | `fix/race-azblob-delete-blobs` | Fix data race on the error in AZBlob.DeleteBlobs | https://github.com/randomizedcoder/geesefs/pull/15 | https://github.com/yandex-cloud/geesefs/pull/229 |
| 16 | `fix/race-azblob-refresh-token` | Fix data race on the container URL in AZBlob.refreshToken | https://github.com/randomizedcoder/geesefs/pull/16 | https://github.com/yandex-cloud/geesefs/pull/230 |
| 17 | `fix/race-lookup-maybe-dir` | Fix data races on the results in LookUpInodeMaybeDir | https://github.com/randomizedcoder/geesefs/pull/17 | https://github.com/yandex-cloud/geesefs/pull/231 |
| 18 | `fix/race-copy-unmodified-parts` | Fix data race on the error in copyUnmodifiedParts | https://github.com/randomizedcoder/geesefs/pull/18 | https://github.com/yandex-cloud/geesefs/pull/232 |
| 19 | `fix/race-multipart-begin-metadata` | Fix data race on user metadata when a multipart upload starts | https://github.com/randomizedcoder/geesefs/pull/19 | https://github.com/yandex-cloud/geesefs/pull/233 |
| 20 | `fix/race-file-handles-atomic` | Read inode.fileHandles with atomics | https://github.com/randomizedcoder/geesefs/pull/20 | https://github.com/yandex-cloud/geesefs/pull/234 |
| 21 | `fix/race-refcnt-atomic` | Access inode.refcnt with atomics only | https://github.com/randomizedcoder/geesefs/pull/21 | https://github.com/yandex-cloud/geesefs/pull/235 |
| 22 | `fix/race-lookup-inode-attrs` | Fix data races in LookUpInode | https://github.com/randomizedcoder/geesefs/pull/22 | https://github.com/yandex-cloud/geesefs/pull/236 |
| 23 | `fix/race-cluster-route-info` | Fix data race on the inode owner in ClusterFs.route | https://github.com/randomizedcoder/geesefs/pull/23 | https://github.com/yandex-cloud/geesefs/pull/237 |

## Upstream PRs (yandex-cloud/geesefs)

| PR | State | Fork PR |
|---|---|---|
| https://github.com/yandex-cloud/geesefs/pull/215 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/1 |
| https://github.com/yandex-cloud/geesefs/pull/216 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/2 |
| https://github.com/yandex-cloud/geesefs/pull/217 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/3 |
| https://github.com/yandex-cloud/geesefs/pull/218 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/4 |
| https://github.com/yandex-cloud/geesefs/pull/219 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/5 |
| https://github.com/yandex-cloud/geesefs/pull/220 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/6 |
| https://github.com/yandex-cloud/geesefs/pull/221 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/7 |
| https://github.com/yandex-cloud/geesefs/pull/222 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/8 |
| https://github.com/yandex-cloud/geesefs/pull/223 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/9 |
| https://github.com/yandex-cloud/geesefs/pull/224 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/10 |
| https://github.com/yandex-cloud/geesefs/pull/225 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/11 |
| https://github.com/yandex-cloud/geesefs/pull/226 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/12 |
| https://github.com/yandex-cloud/geesefs/pull/227 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/13 |
| https://github.com/yandex-cloud/geesefs/pull/228 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/14 |
| https://github.com/yandex-cloud/geesefs/pull/229 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/15 |
| https://github.com/yandex-cloud/geesefs/pull/230 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/16 |
| https://github.com/yandex-cloud/geesefs/pull/231 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/17 |
| https://github.com/yandex-cloud/geesefs/pull/232 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/18 |
| https://github.com/yandex-cloud/geesefs/pull/233 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/19 |
| https://github.com/yandex-cloud/geesefs/pull/234 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/20 |
| https://github.com/yandex-cloud/geesefs/pull/235 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/21 |
| https://github.com/yandex-cloud/geesefs/pull/236 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/22 |
| https://github.com/yandex-cloud/geesefs/pull/237 | open, mergeable; no reviews or CI runs yet | https://github.com/randomizedcoder/geesefs/pull/23 |

## Fork PRs (randomizedcoder/geesefs)

| PR | State | Area | Test |
|---|---|---|---|
| https://github.com/randomizedcoder/geesefs/pull/1 | draft, upstreamed | S3 / GCP IAM | `TestTryIAMErrors` |
| https://github.com/randomizedcoder/geesefs/pull/2 | draft, upstreamed | Azure config | `TestPickAccountKey` |
| https://github.com/randomizedcoder/geesefs/pull/3 | draft, upstreamed | ADLv2 | `TestRenewLeaseStops` |
| https://github.com/randomizedcoder/geesefs/pull/4 | draft, upstreamed | cgroup memory limit | `TestMemoryCgroupDir` |
| https://github.com/randomizedcoder/geesefs/pull/5 | draft, upstreamed | GCS / Azure metadata | `TestPMetadata` |
| https://github.com/randomizedcoder/geesefs/pull/6 | draft, upstreamed | S3 config | `TestS3ConfigInitMultipartCopyThreshold` |
| https://github.com/randomizedcoder/geesefs/pull/7 | draft, upstreamed | S3 V2 signer | `TestV2SignerCanonicalResource` |
| https://github.com/randomizedcoder/geesefs/pull/8 | draft, upstreamed | main: privilege drop | `TestDropPrivileges` |
| https://github.com/randomizedcoder/geesefs/pull/9 | draft, upstreamed | main: --help | `TestCheckArgs` |
| https://github.com/randomizedcoder/geesefs/pull/10 | draft, upstreamed | flusher | `TestAnyFlushInFlight` |
| https://github.com/randomizedcoder/geesefs/pull/11 | draft, upstreamed | flusher: zero parts | `TestZeroPartsToFlush` |
| https://github.com/randomizedcoder/geesefs/pull/12 | draft, upstreamed | flush: missing ETag | `TestUpdateFromFlushETag` |
| https://github.com/randomizedcoder/geesefs/pull/13 | draft, upstreamed | cluster gRPC | `TestToErrno` |
| https://github.com/randomizedcoder/geesefs/pull/14 | draft, upstreamed | GCS backend | `TestGCS3DeleteBlobsConcurrentErrors` |
| https://github.com/randomizedcoder/geesefs/pull/15 | draft, upstreamed | Azure Blob backend | `TestAZBlobDeleteBlobsConcurrentErrors` |
| https://github.com/randomizedcoder/geesefs/pull/16 | draft, upstreamed | Azure Blob SAS token | `TestAZBlobRefreshTokenConcurrent` |
| https://github.com/randomizedcoder/geesefs/pull/17 | draft, upstreamed | lookup (HEAD/LIST) | `TestLookUpInodeMaybeDirConcurrent` |
| https://github.com/randomizedcoder/geesefs/pull/18 | draft, upstreamed | multipart copy | `TestCopyUnmodifiedPartsConcurrentErrors` |
| https://github.com/randomizedcoder/geesefs/pull/19 | draft, upstreamed | multipart begin | `TestBeginMultipartUploadMetadata` |
| https://github.com/randomizedcoder/geesefs/pull/20 | draft, upstreamed | inode fileHandles | `TestFileHandlesConcurrentRead` |
| https://github.com/randomizedcoder/geesefs/pull/21 | draft, upstreamed | inode refcnt | `TestRefcntConcurrentRead` |
| https://github.com/randomizedcoder/geesefs/pull/22 | draft, upstreamed | FUSE LookUpInode | `TestLookUpInodeConcurrentAttributes` |
| https://github.com/randomizedcoder/geesefs/pull/23 | draft, upstreamed | cluster routing | `TestClusterRouteConcurrentOwnerChange` |

## Notes

- #8 and #9 (upstream https://github.com/yandex-cloud/geesefs/pull/222 and
  https://github.com/yandex-cloud/geesefs/pull/223) both add `main_test.go`;
  whichever merges second needs a trivial conflict fix in that file.
- #3 (upstream https://github.com/yandex-cloud/geesefs/pull/217) follow-up: `MultipartBlobAbort` in `core/backend_adlv2.go` never signals
  `RenewLeaseStop`, so an aborted upload still renews its lease until the
  process exits.
- `GOOS=windows go vet ./core` fails on master (`undefined: NewGoofysFuse` in
  `core/goofys_test.go`); this is the `go-vet-windows` flake check failure and
  is not caused by any of these PRs.

- #14-#23 are data-race fixes. Each test runs concurrent scenarios and was
  checked to report `WARNING: DATA RACE` on master under
  `CGO_ENABLED=1 go test -race` (each row in its own process, `-count=20`),
  and to be clean after the fix. Each PR also has a benchmark and a
  benchstat table. #16, #22 and #23 have a second, separate
  performance commit; #18 has a second commit that switches the loops
  in `copyUnmodifiedParts` to `range`.
- #20 (upstream https://github.com/yandex-cloud/geesefs/pull/234) touches
  `sendUploadParts`, which upstream https://github.com/yandex-cloud/geesefs/pull/225
  also changes; expect a trivial conflict, or none.

## Candidates not yet raised

Found in code review, not yet verified in detail or turned into PRs.

| Where | Bug | Why not yet |
|---|---|---|
| `core/backend_azblob.go:240` | SAS token early-renewal condition can never be true (`Add(+buffer)` should be `Add(-buffer)`) | good next candidate |
| `core/backend_gcs3.go` `DeleteBlob` | the ENOENT check on the delete error never matches | good next candidate |
| `core/cluster_fs.go` | plain reads/writes of `fileHandles`, `refcnt` and `CacheState` (the same races as #20, #21 and #22, in cluster mode) | cluster mode; left out of #20/#21 on purpose |
| `core/goofys_fuse.go` `CreateSymlink`, `CreateFile`, `MkNode`, `MkDir` | `InflateAttributes()` and `Attributes` writes without `inode.mu` on the new inode | follow-up to #22, larger change |
| `core/dir.go` `renameRecursive` | TODO on the inode ID swap; the swap is not atomic as a whole | needs a design decision |
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
