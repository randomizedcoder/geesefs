# nix/lib/version.nix
#
# The geesefs version string, read from the GEESEFS_VERSION constant in
# core/cfg/flags.go so the Nix packages and `geesefs --version` cannot disagree.
#
# Why not `-X main.Version=…` like the Makefile and Dockerfile.build: there is
# no `main.Version` variable, so that flag is a silent no-op. The version the
# binary actually reports is the constant read here.
#
{ src }:

let
  flags = builtins.readFile "${src}/core/cfg/flags.go";
  m = builtins.match ''.*const GEESEFS_VERSION = "([^"]+)".*'' flags;
in
if m == null then
  throw "nix/lib/version.nix: GEESEFS_VERSION not found in core/cfg/flags.go"
else
  builtins.head m
