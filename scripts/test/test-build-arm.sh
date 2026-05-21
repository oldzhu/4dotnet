#!/usr/bin/env bash
# test-build-arm.sh — Build verification test for ARM target
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
setup_test "Build Verification — ARM"

BUILDROOT_DIR="${BUILDROOT_DIR:-/home/oldzhu/buildroot}"
FOURDOTNET_DIR="${FOURDOTNET_DIR:-/home/oldzhu/4dotnet}"

if [[ ! -d "$BUILDROOT_DIR" ]]; then
    log_skip "ARM build verification" "Buildroot not found at $BUILDROOT_DIR"
    save_evidence "task-12-build-arm" "SKIP: Buildroot not found"
    teardown_test
    exit 0
fi

log_info "Running defconfig for arm..."
cd "$BUILDROOT_DIR"
if make BR2_EXTERNAL="$FOURDOTNET_DIR" defconfig BR2_DEFCONFIG="$FOURDOTNET_DIR/savedconfigs/arm/br2.defconfig" 2>&1; then
    log_pass "ARM defconfig succeeded"
else
    log_fail "ARM defconfig failed"
    save_evidence "task-12-build-arm" "FAIL: defconfig failed"
    teardown_test
    exit 1
fi

assert_file_exists "ARM .config generated" "$BUILDROOT_DIR/.config"
save_evidence "task-12-build-arm" "PASS: defconfig succeeded"
teardown_test
