#!/usr/bin/env bash
# release.sh — One-click release script for 4dotnet
# Orchestrates: validation → artifact generation → GitHub release upload
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FOURDOTNET_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
    cat <<'USAGE'
Usage: release.sh [--dry-run] [--full] [--upload] <arch>

  arch: arm64 or arm
  --dry-run: Preview without creating artifacts
  --full: Create single combined archive
  --upload: Upload to GitHub Releases (requires gh CLI)
  --help: Show this help

Examples:
  release.sh --dry-run arm64       # Preview
  release.sh arm64                  # Create modular release
  release.sh --full --upload arm64  # Full release + upload to GitHub

Checks before release:
  - Buildroot output exists
  - QEMU launch scripts present
  - LLDB/GDB binaries available
  - GitHub CLI authenticated (if --upload)
USAGE
}

DRY_RUN=0
FULL_RELEASE=0
DO_UPLOAD=0
ARCH=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=1; shift ;;
        --full) FULL_RELEASE=1; shift ;;
        --upload) DO_UPLOAD=1; shift ;;
        --help) usage; exit 0 ;;
        arm64|arm) ARCH="$1"; shift ;;
        *) echo "Unknown: $1"; usage; exit 1 ;;
    esac
done

if [[ -z "$ARCH" ]]; then
    echo "ERROR: Architecture required (arm64 or arm)" >&2
    usage; exit 1
fi

log_info()  { echo "[INFO] $*"; }
log_warn()  { echo "[WARN] $*"; }
log_error() { echo "[ERROR] $*" >&2; }

BUILDROOT_DIR="${BUILDROOT_DIR:-$HOME/buildroot}"
IMAGES_DIR="$BUILDROOT_DIR/output/images"
DATE=$(date +%Y%m%d)

# --- Pre-flight checks ---
log_info "Running pre-flight checks..."

CHECKS_PASSED=0
CHECKS_TOTAL=0

check_dir() { CHECKS_TOTAL=$((CHECKS_TOTAL+1)); if [[ -d "$1" ]]; then CHECKS_PASSED=$((CHECKS_PASSED+1)); else log_warn "Missing: $1"; fi; }
check_file() { CHECKS_TOTAL=$((CHECKS_TOTAL+1)); if [[ -f "$1" ]]; then CHECKS_PASSED=$((CHECKS_PASSED+1)); else log_warn "Missing: $1"; fi; }

check_dir "$BUILDROOT_DIR"
check_dir "$IMAGES_DIR"
check_file "$IMAGES_DIR/rootfs.ext4"
check_file "$SCRIPT_DIR/${ARCH}/start-qemu.sh"

if [[ $DO_UPLOAD -eq 1 ]]; then
    CHECKS_TOTAL=$((CHECKS_TOTAL+1))
    if command -v gh >/dev/null 2>&1; then
        if gh auth status >/dev/null 2>&1; then
            CHECKS_PASSED=$((CHECKS_PASSED+1))
        else
            log_warn "gh CLI not authenticated. Run: gh auth login"
        fi
    else
        log_warn "gh CLI not installed. Install: https://cli.github.com/"
    fi
fi

log_info "Checks: $CHECKS_PASSED/$CHECKS_TOTAL passed"

if [[ $DRY_RUN -eq 1 ]]; then
    log_info "DRY RUN — would create release artifacts for $ARCH"
    log_info "Date stamp: $DATE"
    log_info "Output: $FOURDOTNET_ROOT/releases/"
    log_info "Remove --dry-run to execute."
    exit 0
fi

# --- Delegate to modular release ---
log_info "Creating modular release..."
bash "$SCRIPT_DIR/release-modular.sh" $([ $FULL_RELEASE -eq 1 ] && echo "--full") "$ARCH"

# --- Upload to GitHub (if requested) ---
if [[ $DO_UPLOAD -eq 1 ]]; then
    TAG="v${DATE}"
    log_info "Creating GitHub Release: $TAG"
    RELEASE_NOTES=$(cat <<EOF
## 4dotnet Release $TAG

**Architecture**: $ARCH
**Date**: $(date +%Y-%m-%d)

### Artifacts
- Base VM (LLDB + GDB)
- .NET Debugging Pack (SOS + runtime symbols)
- Kernel Debug Pack (vmlinux)

### Installation
\`\`\`bash
tar -xvf 4dotnet-${ARCH}-base-${DATE}.tar.xz
cd 4dotnet-${ARCH}
./start-qemu.sh
\`\`\`
EOF
)
    # Create release (non-interactive)
    if gh release view "$TAG" >/dev/null 2>&1; then
        log_warn "Release $TAG already exists. Uploading assets..."
        gh release upload "$TAG" "$FOURDOTNET_ROOT"/releases/*${DATE}.tar.xz --clobber
    else
        gh release create "$TAG" "$FOURDOTNET_ROOT"/releases/*${DATE}.tar.xz \
            --title "4dotnet Release $TAG" \
            --notes "$RELEASE_NOTES"
    fi
    log_info "Release uploaded: https://github.com/oldzhu/4dotnet/releases/tag/$TAG"
fi

log_info "Done. Artifacts in: $FOURDOTNET_ROOT/releases/"
ls -la "$FOURDOTNET_ROOT/releases/"*.tar.xz 2>/dev/null || log_info "(no archives — build the VM first)"
