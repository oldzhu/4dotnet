#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FOURDOTNET_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Default assumption: buildroot is a sibling folder next to 4dotnet.
DEFAULT_BUILDROOT_DIR="$FOURDOTNET_ROOT/../buildroot"
BUILDROOT_DIR="${BUILDROOT_DIR:-$DEFAULT_BUILDROOT_DIR}"

IMAGE_NAME="${IMAGE_NAME:-4dotnet-build-env:local}"
ENGINE="${ENGINE:-}"

# Optional knobs for restricted networks / proxies
BUILD_NETWORK="${BUILD_NETWORK:-}"

# Cache directories (persistent across container runs)
CCACHE_DIR_HOST="${CCACHE_DIR_HOST:-$HOME/.cache/4dotnet-ccache}"
DL_DIR="${DL_DIR:-$BUILDROOT_DIR/dl}"

usage() {
  cat <<'USAGE'
Usage:
  tools/build-env/run.sh [--engine docker|podman] [--build] [--clean-caches] [--] [command...]

Examples:
  # Build the container image (once)
  tools/build-env/run.sh --build

  # Configure for arm64 using the existing defconfig
  tools/build-env/run.sh -- make distclean
  tools/build-env/run.sh -- make BR2_EXTERNAL=/work/4dotnet defconfig \
      BR2_DEFCONFIG=/work/4dotnet/savedconfigs/arm64/br2.defconfig

  # Build
  tools/build-env/run.sh -- make

  # Clean build caches
  tools/build-env/run.sh --clean-caches

Notes:
  - This wrapper sets HOME=/work inside the container so repo scripts using
    "$HOME/buildroot" continue to work.
  - Override BUILDROOT_DIR if your buildroot folder is elsewhere.
  - Persistent caches: dl/ (downloads) and ccache are mounted from the host.
    Set CCACHE_DIR_HOST and DL_DIR to customize paths.
  - The --clean-caches flag removes dl/ contents and ccache.
USAGE
}

if [[ ! -d "$BUILDROOT_DIR" ]]; then
  echo "ERROR: BUILDROOT_DIR does not exist: $BUILDROOT_DIR" >&2
  echo "Set BUILDROOT_DIR=/path/to/buildroot and retry." >&2
  exit 2
fi

if [[ -z "$ENGINE" ]]; then
  if command -v docker >/dev/null 2>&1; then
    ENGINE="docker"
  elif command -v podman >/dev/null 2>&1; then
    ENGINE="podman"
  else
    echo "ERROR: Neither docker nor podman found on PATH." >&2
    exit 2
  fi
fi

DO_BUILD=0
DO_CLEAN_CACHES=0
if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --engine)
      ENGINE="$2"; shift 2 ;;
    --build)
      DO_BUILD=1; shift ;;
    --clean-caches)
      DO_CLEAN_CACHES=1; shift ;;
    --)
      shift; break ;;
    *)
      break ;;
  esac
done

if [[ "$ENGINE" != "docker" && "$ENGINE" != "podman" ]]; then
  echo "ERROR: Unsupported engine: $ENGINE (expected docker or podman)" >&2
  exit 2
fi

# Handle cache cleanup
if [[ $DO_CLEAN_CACHES -eq 1 ]]; then
  echo "Cleaning build caches..."
  if [[ -d "$DL_DIR" ]]; then
    echo "  Removing dl/ contents: $DL_DIR"
    rm -rf "$DL_DIR"/*
  fi
  if [[ -d "$CCACHE_DIR_HOST" ]]; then
    echo "  Removing ccache: $CCACHE_DIR_HOST"
    rm -rf "$CCACHE_DIR_HOST"/*
  fi
  echo "Caches cleaned."
  exit 0
fi

if [[ $DO_BUILD -eq 1 ]]; then
  BUILD_ARGS=()
  if [[ -n "${APT_MIRROR:-}" ]]; then
    BUILD_ARGS+=(--build-arg "APT_MIRROR=${APT_MIRROR}")
  fi
  if [[ -n "${APT_SECURITY_MIRROR:-}" ]]; then
    BUILD_ARGS+=(--build-arg "APT_SECURITY_MIRROR=${APT_SECURITY_MIRROR}")
  fi

  # Proxy passthrough (common in enterprise networks)
  for p in http_proxy https_proxy no_proxy HTTP_PROXY HTTPS_PROXY NO_PROXY; do
    if [[ -n "${!p:-}" ]]; then
      BUILD_ARGS+=(--build-arg "$p=${!p}")
    fi
  done

  BUILD_OPTS=()
  if [[ -n "$BUILD_NETWORK" ]]; then
    BUILD_OPTS+=(--network "$BUILD_NETWORK")
  fi

  "$ENGINE" build \
    -f "$FOURDOTNET_ROOT/tools/build-env/Dockerfile" \
    -t "$IMAGE_NAME" \
    "${BUILD_OPTS[@]}" \
    "${BUILD_ARGS[@]}" \
    "$FOURDOTNET_ROOT/tools/build-env"
fi

# Default command: interactive shell.
if [[ $# -eq 0 ]]; then
  set -- bash
fi

UID_GID="$(id -u):$(id -g)"

# Detect TTY: use -it only if stdin is a terminal
if [[ -t 0 ]]; then
  TTY_FLAGS="-it"
else
  TTY_FLAGS="-i"
fi

# Ensure cache directories exist
mkdir -p "$DL_DIR" "$CCACHE_DIR_HOST"

exec "$ENGINE" run --rm $TTY_FLAGS \
  --user "$UID_GID" \
  -e HOME=/work \
  -e BR2_EXTERNAL=/work/4dotnet \
  -e CCACHE_DIR=/work/.ccache \
  -w /work/buildroot \
  -v "$BUILDROOT_DIR:/work/buildroot" \
  -v "$FOURDOTNET_ROOT:/work/4dotnet" \
  -v "$DL_DIR:/work/buildroot/dl" \
  -v "$CCACHE_DIR_HOST:/work/.ccache" \
  "$IMAGE_NAME" "$@"
