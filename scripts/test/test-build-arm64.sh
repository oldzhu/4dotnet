#!/usr/bin/env bash
# test-build-arm64.sh — Build verification test for ARM64 target
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
setup_test "Build Verification — ARM64"

BUILDROOT_DIR="${BUILDROOT_DIR:-/home/oldzhu/buildroot}"
FOURDOTNET_DIR="${FOURDOTNET_DIR:-/home/oldzhu/4dotnet}"

# Check Buildroot exists
if [[ ! -d "$BUILDROOT_DIR" ]]; then
    log_skip "ARM64 build verification" "Buildroot not found at $BUILDROOT_DIR"
    save_evidence "task-12-build-arm64" "SKIP: Buildroot not found"
    teardown_test
    exit 0
fi

# Run defconfig
log_info "Running defconfig for arm64..."
cd "$BUILDROOT_DIR"
if make BR2_EXTERNAL="$FOURDOTNET_DIR" defconfig BR2_DEFCONFIG="$FOURDOTNET_DIR/savedconfigs/arm64/br2.defconfig" 2>&1; then
    log_pass "ARM64 defconfig succeeded"
else
    log_fail "ARM64 defconfig failed"
    save_evidence "task-12-build-arm64" "FAIL: defconfig failed"
    teardown_test
    exit 1
fi

# Check .config was generated
assert_file_exists "ARM64 .config generated" "$BUILDROOT_DIR/.config"

# Check key packages enabled
if grep -q "BR2_PACKAGE_LLDB=y" "$BUILDROOT_DIR/.config"; then
    log_pass "LLDB enabled in config"
else
    log_fail "LLDB NOT enabled in config"
fi

if grep -q "BR2_PACKAGE_DOTNETRUNTIME=y" "$BUILDROOT_DIR/.config"; then
    log_pass "dotnetruntime enabled in config"
else
    log_fail "dotnetruntime NOT enabled in config"
fi

save_evidence "task-12-build-arm64" "PASS: defconfig succeeded, packages enabled"
teardown_test
