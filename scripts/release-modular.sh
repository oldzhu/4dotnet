#!/usr/bin/env bash
# release-modular.sh — Modular GitHub Release creation for 4dotnet
# Creates: Base VM + .NET Debug Pack + Kernel Debug Pack
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FOURDOTNET_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILDROOT_DIR="${BUILDROOT_DIR:-$HOME/buildroot}"

usage() {
    cat <<'USAGE'
Usage: release-modular.sh [--dry-run] [--full] <arch>

  arch: arm64 or arm
  --dry-run: Show what would be done without creating files
  --full: Create a single combined archive instead of modular packs
  --help: Show this help

Examples:
  release-modular.sh --dry-run arm64
  release-modular.sh arm64
  release-modular.sh --full arm
USAGE
}

DRY_RUN=0
FULL_RELEASE=0
ARCH=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=1; shift ;;
        --full) FULL_RELEASE=1; shift ;;
        --help) usage; exit 0 ;;
        arm64|arm) ARCH="$1"; shift ;;
        *) echo "Unknown: $1"; usage; exit 1 ;;
    esac
done

if [[ -z "$ARCH" ]]; then
    echo "ERROR: architecture required (arm64 or arm)" >&2
    usage; exit 1
fi

DATE=$(date +%Y%m%d)
IMAGES_DIR="$BUILDROOT_DIR/output/images"
RELEASE_DIR="$FOURDOTNET_ROOT/releases/${ARCH}-${DATE}"

log_info() { echo "[INFO] $*"; }
log_dry() { echo "[DRY-RUN] Would: $*"; }

if [[ $DRY_RUN -eq 1 ]]; then
    log_dry "Create release directory: $RELEASE_DIR"
    log_dry "Copy kernel Image/zImage from $IMAGES_DIR"
    log_dry "Copy rootfs.ext4 from $IMAGES_DIR"
    log_dry "Copy LLDB/GDB binaries"
    log_dry "Create 4dotnet-${ARCH}-base-${DATE}.tar.xz"
    if [[ $FULL_RELEASE -eq 0 ]]; then
        log_dry "Create 4dotnet-${ARCH}-debug-pack-${DATE}.tar.xz (SOS + runtime)"
        log_dry "Create 4dotnet-${ARCH}-kernel-debug-${DATE}.tar.xz (vmlinux)"
    else
        log_dry "Create 4dotnet-${ARCH}-full-${DATE}.tar.xz"
    fi
    log_info "Dry run complete. Remove --dry-run to execute."
    exit 0
fi

# Check prerequisites
if [[ ! -d "$IMAGES_DIR" ]]; then
    echo "ERROR: Build images not found at $IMAGES_DIR" >&2
    echo "Run Buildroot build first." >&2
    exit 2
fi

mkdir -p "$RELEASE_DIR"

log_info "Creating modular release for $ARCH..."

# Base VM
BASE_DIR="$RELEASE_DIR/base"
mkdir -p "$BASE_DIR"
cp "$IMAGES_DIR/rootfs.ext4" "$BASE_DIR/" 2>/dev/null || log_info "rootfs.ext4 not found (may need full build)"
if [[ "$ARCH" == "arm64" ]]; then
    cp "$IMAGES_DIR/Image" "$BASE_DIR/" 2>/dev/null || true
else
    cp "$IMAGES_DIR/zImage" "$BASE_DIR/" 2>/dev/null || true
fi
# Copy QEMU launch scripts
cp "$SCRIPT_DIR/${ARCH}/start-qemu.sh" "$BASE_DIR/" 2>/dev/null || true

BASE_ARCHIVE="$FOURDOTNET_ROOT/releases/4dotnet-${ARCH}-base-${DATE}.tar.xz"
tar -cJf "$BASE_ARCHIVE" -C "$RELEASE_DIR" base/
log_info "Base VM: $BASE_ARCHIVE"

if [[ $FULL_RELEASE -eq 0 ]]; then
    # .NET Debug Pack
    DEBUG_DIR="$RELEASE_DIR/debug-pack"
    mkdir -p "$DEBUG_DIR"
    TARGET_DIR="$BUILDROOT_DIR/output/target"
    if [[ -d "$TARGET_DIR/root/dotnethello" ]]; then
        cp -r "$TARGET_DIR/root/dotnethello" "$DEBUG_DIR/" 2>/dev/null || true
    fi
    if [[ -d "$TARGET_DIR/usr/lib" ]]; then
        find "$TARGET_DIR/usr/lib" -name "libcoreclr*" -o -name "libhostfxr*" -o -name "libhostpolicy*" 2>/dev/null | while read f; do
            mkdir -p "$DEBUG_DIR/usr/lib"
            cp "$f" "$DEBUG_DIR/usr/lib/" 2>/dev/null || true
        done
    fi
    DEBUG_ARCHIVE="$FOURDOTNET_ROOT/releases/4dotnet-${ARCH}-debug-pack-${DATE}.tar.xz"
    tar -cJf "$DEBUG_ARCHIVE" -C "$RELEASE_DIR" debug-pack/ 2>/dev/null || log_info "Debug pack empty (build may be needed)"
    log_info "Debug Pack: $DEBUG_ARCHIVE"

    # Kernel Debug Pack
    KERNEL_DIR="$RELEASE_DIR/kernel-debug"
    mkdir -p "$KERNEL_DIR"
    VMLINUX=$(find "$BUILDROOT_DIR/output/build" -name "vmlinux" -type f 2>/dev/null | head -1)
    if [[ -n "$VMLINUX" ]]; then
        cp "$VMLINUX" "$KERNEL_DIR/"
    fi
    KERNEL_ARCHIVE="$FOURDOTNET_ROOT/releases/4dotnet-${ARCH}-kernel-debug-${DATE}.tar.xz"
    tar -cJf "$KERNEL_ARCHIVE" -C "$RELEASE_DIR" kernel-debug/ 2>/dev/null || log_info "Kernel debug pack empty"
    log_info "Kernel Debug Pack: $KERNEL_ARCHIVE"
else
    # Full combined release
    FULL_ARCHIVE="$FOURDOTNET_ROOT/releases/4dotnet-${ARCH}-full-${DATE}.tar.xz"
    tar -cJf "$FULL_ARCHIVE" -C "$RELEASE_DIR" base/
    log_info "Full Release: $FULL_ARCHIVE"
fi

log_info "Release artifacts created in: $FOURDOTNET_ROOT/releases/"
ls -la "$FOURDOTNET_ROOT/releases/"*.tar.xz 2>/dev/null || echo "(no archives yet — full build needed)"

log_info "To upload to GitHub Releases, run:"
echo "  gh release create v${DATE} $FOURDOTNET_ROOT/releases/*${DATE}.tar.xz --title '4dotnet Release ${DATE}'"
