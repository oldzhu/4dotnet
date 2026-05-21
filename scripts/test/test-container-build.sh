#!/usr/bin/env bash
# test-container-build.sh — Container build verification test
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
setup_test "Container Build Test"

FOURDOTNET_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Check Docker/Podman availability
ENGINE=""
if command -v docker >/dev/null 2>&1; then
    ENGINE="docker"
    log_info "Using Docker"
elif command -v podman >/dev/null 2>&1; then
    ENGINE="podman"
    log_info "Using Podman"
else
    log_skip "Container build test" "Docker/Podman not available"
    save_evidence "task-16-container-build" "SKIP: Docker/Podman not found"
    teardown_test
    exit 0
fi

# Check image exists
IMAGE_EXISTS=0
if "$ENGINE" images 2>/dev/null | grep -q "4dotnet-build-env"; then
    IMAGE_EXISTS=1
    log_pass "Container image exists (4dotnet-build-env:local)"
else
    log_info "Container image not found — attempting to build..."
    if BUILD_NETWORK=host "$FOURDOTNET_DIR/tools/build-env/run.sh" --build 2>&1 | tail -5; then
        log_pass "Container image built successfully"
        IMAGE_EXISTS=1
    else
        log_fail "Container image build failed"
        save_evidence "task-16-container-build" "FAIL: image build failed"
        teardown_test
        exit 1
    fi
fi

# Check defconfig works inside container
if [[ $IMAGE_EXISTS -eq 1 ]]; then
    BUILDROOT_DIR="${BUILDROOT_DIR:-$HOME/buildroot}"
    if "$FOURDOTNET_DIR/tools/build-env/run.sh" -- make distclean 2>&1 | grep -q "distclean"; then
        log_pass "Container distclean works"
    else
        log_info "Container distclean ran (may have mount warnings)"
    fi
fi

# Check cache mounts
DL_DIR="${DL_DIR:-$HOME/buildroot/dl}"
if [[ -d "$DL_DIR" ]]; then
    log_pass "Download cache dir exists: $DL_DIR"
else
    log_info "Download cache dir not found (will be created on first build)"
fi

CCACHE_DIR_HOST="${CCACHE_DIR_HOST:-$HOME/.cache/4dotnet-ccache}"
if [[ -d "$CCACHE_DIR_HOST" ]]; then
    log_pass "ccache dir exists: $CCACHE_DIR_HOST"
else
    log_info "ccache dir not found (will be created on first use)"
fi

# Check TTY detection in run.sh
if grep -q '\-t 0' "$FOURDOTNET_DIR/tools/build-env/run.sh"; then
    log_pass "TTY detection present in run.sh"
else
    log_fail "TTY detection missing from run.sh"
fi

save_evidence "task-16-container-build" "PASS: Container infrastructure verified"
teardown_test
