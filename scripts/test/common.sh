#!/usr/bin/env bash
# common.sh — Shared test helper functions for 4dotnet test framework
set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
TESTS_PASSED=0; TESTS_FAILED=0; TESTS_SKIPPED=0
EVIDENCE_DIR="${EVIDENCE_DIR:-/home/oldzhu/4dotnet/.sisyphus/evidence}"
log_info() { echo -e "${YELLOW}[INFO]${NC} $*"; }
log_pass() { echo -e "${GREEN}[PASS]${NC} $*"; TESTS_PASSED=$((TESTS_PASSED+1)); }
log_fail() { echo -e "${RED}[FAIL]${NC} $*"; TESTS_FAILED=$((TESTS_FAILED+1)); }
log_skip() { echo -e "${YELLOW}[SKIP]${NC} $*"; TESTS_SKIPPED=$((TESTS_SKIPPED+1)); }
assert_eq() { local n="$1" e="$2" a="$3"; if [ "$e" = "$a" ]; then log_pass "$n"; else log_fail "$n — expected '$e', got '$a'"; fi; }
assert_contains() { local n="$1" nd="$2" h="$3"; if echo "$h" | grep -qF "$nd"; then log_pass "$n"; else log_fail "$n — expected output to contain '$nd'"; fi; }
assert_file_exists() { local n="$1" f="$2"; if [ -f "$f" ]; then log_pass "$n"; else log_fail "$n — file not found: $f"; fi; }
assert_dir_exists() { local n="$1" d="$2"; if [ -d "$d" ]; then log_pass "$n"; else log_fail "$n — dir not found: $d"; fi; }
assert_exit_code() { local n="$1" e="$2"; shift 2; local out; if out=$("$@" 2>&1); then a=0; else a=$?; fi; if [ "$a" = "$e" ]; then log_pass "$n"; else log_fail "$n — expected exit $e, got $a"; echo "  Output: $out"; fi; }
setup_test() { echo ""; echo "============================================"; echo " Test: $1"; echo "============================================"; mkdir -p "$EVIDENCE_DIR"; }
teardown_test() { echo "--------------------------------------------"; echo " Results: ${GREEN}$TESTS_PASSED passed${NC}, ${RED}$TESTS_FAILED failed${NC}, ${YELLOW}$TESTS_SKIPPED skipped${NC}"; echo ""; }
save_evidence() { local n="$1" c="$2"; local f="$EVIDENCE_DIR/${n}.txt"; echo "$c" > "$f"; log_info "Evidence saved: $f"; }
