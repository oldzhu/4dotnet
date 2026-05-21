#!/usr/bin/env bash
# test-vm-boot-arm64.sh — VM boot verification test for ARM64
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
setup_test "VM Boot Test — ARM64"

FOURDOTNET_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILDROOT_DIR="${BUILDROOT_DIR:-$HOME/buildroot}"
IMAGES_DIR="$BUILDROOT_DIR/output/images"

# Check prerequisites
if [[ ! -f "$IMAGES_DIR/rootfs.ext4" ]]; then
    log_skip "VM boot ARM64" "VM image not found at $IMAGES_DIR (build first)"
    save_evidence "task-15-vm-boot-arm64" "SKIP: VM image not built"
    teardown_test
    exit 0
fi

if [[ ! -f "$IMAGES_DIR/Image" ]]; then
    log_skip "VM boot ARM64" "Kernel Image not found at $IMAGES_DIR"
    save_evidence "task-15-vm-boot-arm64" "SKIP: kernel not built"
    teardown_test
    exit 0
fi

if ! command -v qemu-system-aarch64 >/dev/null 2>&1; then
    QEMU="$BUILDROOT_DIR/output/host/bin/qemu-system-aarch64"
    if [[ ! -f "$QEMU" ]]; then
        log_skip "VM boot ARM64" "QEMU not available (install or build first)"
        save_evidence "task-15-vm-boot-arm64" "SKIP: QEMU not found"
        teardown_test
        exit 0
    fi
else
    QEMU="qemu-system-aarch64"
fi

# Boot VM with timeout (120s)
log_info "Starting QEMU ARM64 VM (timeout: 120s)..."
timeout 120 "$QEMU" \
    -M virt -cpu cortex-a53 -nographic -smp 2 -m 2048 \
    -kernel "$IMAGES_DIR/Image" \
    -append "rootwait root=/dev/vda console=ttyAMA0" \
    -drive file="$IMAGES_DIR/rootfs.ext4,if=none,format=raw,id=hd0" \
    -device virtio-blk-device,drive=hd0 \
    2>&1 | tee /tmp/vm-boot-arm64.log | head -50 &
QEMU_PID=$!

# Wait for login prompt
for i in $(seq 1 24); do
    sleep 5
    if grep -q "Welcome to Buildroot\|buildroot login:" /tmp/vm-boot-arm64.log 2>/dev/null; then
        log_pass "VM booted successfully (login prompt detected)"
        kill $QEMU_PID 2>/dev/null || true
        save_evidence "task-15-vm-boot-arm64" "PASS: VM booted, login prompt detected"
        teardown_test
        exit 0
    fi
done

log_fail "VM boot timed out (no login prompt within 120s)"
kill $QEMU_PID 2>/dev/null || true
save_evidence "task-15-vm-boot-arm64" "FAIL: timeout — no login prompt"
teardown_test
exit 1
