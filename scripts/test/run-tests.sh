#!/usr/bin/env bash
# run-tests.sh — Test orchestrator for 4dotnet
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"
setup_test "4dotnet Test Suite"
for test_file in "$SCRIPT_DIR"/test-*.sh; do
    if [ -x "$test_file" ]; then
        log_info "Running: $(basename "$test_file")"
        bash "$test_file" || true
    else
        log_skip "$(basename "$test_file")" "not executable or no tests defined"
    fi
done
teardown_test
[ "$TESTS_FAILED" -gt 0 ] && exit 1; exit 0
