#!/usr/bin/env bash
# test-vm-boot-arm.sh — VM boot verification test for ARM
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
setup_test "VM Boot Test — ARM"

BUILDROOT_DIR="${BUILDROOT_DIR:-$HOME/buildroot}"
IMAGES_DIR="$BUILDROOT_DIR/output/images"

if [[ ! -f "$IMAGES_DIR/rootfs.ext4" ]]; then
    log_skip "VM boot ARM" "VM image not found (build first)"
    save_evidence "task-15-vm-boot-arm" "SKIP: VM image not built"
    teardown_test
    exit 0
fi

if [[ ! -f "$IMAGES_DIR/zImage" ]]; then
    log_skip "VM boot ARM" "Kernel zImage not found"
    save_evidence "task-15-vm-boot-arm" "SKIP: kernel not built"
    teardown_test
    exit 0
fi

log_skip "VM boot ARM" "ARM VM boot test requires QEMU ARM — use manual testing for now"
save_evidence "task-15-vm-boot-arm" "SKIP: ARM QEMU boot not automated (use interactive testing)"
teardown_test
