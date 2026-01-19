# 4dotnet – Next Steps & Progress Tracking

Date: 2026-01-19

This document tracks what we decided, what is already done, and what we plan to do next.

## Goals

- Keep the “download and run” experience, but avoid shipping a massive release bundle.
- Keep “build from source” available, but remove host dependency/setup pain.
- Stay on **GitHub Releases only** (for now).

## Key Decisions (current)

- Base VM includes **LLDB + GDB**.
- Base VM does **not** include SOS.
- SOS ships in the **.NET Debugging pack** (optional download).
- Distribution channel: **GitHub Releases only**.

## Progress Done

### Containerized build environment

- Added Docker/Podman build environment for Buildroot + external tree:
  - `tools/build-env/Dockerfile` (Ubuntu 24.04)
  - `tools/build-env/run.sh`
  - `documents/build-container.md`
- Linked container workflow from:
  - `README.md`
  - `documents/build.md`
- Network reliability notes:
  - `BUILD_NETWORK=host` can be used for `--build` when Docker build networking is restricted.
  - Supports optional `APT_MIRROR` / `APT_SECURITY_MIRROR` and proxy passthrough.

### Sanity check

- Confirmed inside-container Buildroot config works:
  - `make BR2_EXTERNAL=/work/4dotnet defconfig BR2_DEFCONFIG=/work/4dotnet/savedconfigs/arm64/br2.defconfig`

## Next Steps (recommended order)

### 1) Smoke test (short)

Objective: confirm the container workflow proceeds beyond `defconfig`.

- Build the image (if needed):
  - `BUILD_NETWORK=host ./tools/build-env/run.sh --build`
- Configure (arm64 example):
  - `./tools/build-env/run.sh -- make distclean`
  - `./tools/build-env/run.sh -- make BR2_EXTERNAL=/work/4dotnet defconfig BR2_DEFCONFIG=/work/4dotnet/savedconfigs/arm64/br2.defconfig`
- Start build and stop after it clearly begins downloads/toolchain work:
  - `./tools/build-env/run.sh -- make`

Deliverable: a short note of what succeeded/failed + any missing packages.

### 2) Improve container workflow for real builds (high ROI)

Objective: make repeated builds fast and avoid re-downloading everything.

- Persist Buildroot `dl/` and `output/` on the host (via mounts).
- Optional: enable `ccache` (host dir mounted) for faster rebuilds.
- Document recommended host disk layout + cleanup steps.

Deliverable: updated `tools/build-env/run.sh` + docs.

### 3) Modular GitHub Release redesign (Base VM + packs)

Objective: small base download + optional debug assets on-demand.

- Define release artifact layout:
  - Base VM (bootable + LLDB/GDB)
  - Optional packs:
    - .NET Debugging pack (includes SOS + runtime/native symbols you build)
    - Kernel debug pack (vmlinux, System.map, modules/symbols)
    - Optional: sources pack (only if truly needed offline)
- Create a `manifest.json` per release with:
  - arch, versions, asset filenames, sizes, sha256
- Add a tiny helper tool (script/CLI) to:
  - list assets, download selected packs, verify sha256, run QEMU

Deliverable: manifest schema + sample manifest + helper script + docs.

### 4) Automate release generation

Objective: reproducible releases and less manual work.

- One pipeline/job that:
  - builds base + packs
  - generates checksums + manifest
  - uploads assets to GitHub Release

Deliverable: CI workflow (likely GitHub Actions) + release instructions.

## Open Questions / To Decide Later

- Size target for Base VM (e.g. <500MB? <1GB?).
- Which symbols must be in the .NET Debugging pack vs fetched from symbol servers.
- Whether to pin exact commits/tags for kernel/runtime/llvm in releases.
