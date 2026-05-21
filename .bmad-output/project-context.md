# Project Context: 4dotnet

> **Auto-generated from codebase analysis and planning session — 2026-05-21**

## Project Identity

**4dotnet** is a **Buildroot external tree** that builds complete ARM/ARM64 Linux virtual machines pre-configured for .NET Core debugging — from QEMU through the Linux kernel, LLDB/GDB, SOS plugin, to the .NET runtime itself.

### Core Goals
1. Lower the barrier to playing with .NET Core on Linux ARM/ARM64 (no real hardware needed)
2. Provide an "All-In-One" full-stack debugging experience in the OSS world: QEMU → Linux Kernel → LLDB/GDB → SOS → .NET Core App

## Technology Stack

| Layer | Component | Current Version | Notes |
|-------|-----------|-----------------|-------|
| **Build System** | Buildroot | External tree | `external.mk`, `external.desc`, `Config.in` |
| **Container Build** | Docker/Podman | Ubuntu 24.04 | `tools/build-env/` |
| **VM Host** | QEMU | 7.1.0 | Built by Buildroot gcc toolchain |
| **C/C++ Toolchain** | LLVM/Clang/LLD | 17.0.6 (tarball) | Cross-compiles SOS native + .NET runtime native |
| **Debugger** | LLDB | 17.0.6 | Target + host builds |
| **Debugger** | GDB | 12 | Built by Buildroot gcc toolchain |
| **.NET Runtime** | dotnet/runtime | v8.0.0 (tarball) | Cross-compiled for ARM/ARM64 |
| **Diagnostics** | diagnostics | main branch | SOS plugin + diagnostic tools |
| **CLR MD** | clrmd | main branch | Microsoft.Diagnostics.Runtime |
| **Monitor** | dotnet-monitor | main branch | .NET monitoring tool |
| **Demo App** | dotnethello | 1.0 | Self-contained .NET console app |
| **.NET SDK** | dotnetsdk | master (ARM64 only) | Optional SDK package |

## Target Architectures

| Architecture | Buildroot Arch | QEMU Machine |
|-------------|---------------|--------------|
| ARM64 (aarch64) | `BR2_aarch64` | `-M virt -cpu cortex-a53` |
| ARM (armv7) | `BR2_arm` | `-M vexpress-a9` |

## Build System Architecture

### Buildroot External Tree Pattern
```
4dotnet/
├── external.mk          # Includes all package/*/*.mk
├── external.desc        # name: 4dotnet
├── Config.in            # Sources all package Config.in files
├── package/             # 8 Buildroot packages
│   ├── hello/           # Simple C test program
│   ├── lldb/            # LLDB (v15-v17 versions)
│   ├── dotnetcore/
│   │   ├── dotnetruntime/  # .NET Runtime
│   │   ├── diagnostics/    # SOS + diagnostics
│   │   ├── clrmd/          # CLR metadata reader
│   │   ├── dotnet-monitor/ # Monitoring tools
│   │   └── symstore/       # Symbol store (disabled)
│   ├── dotnethello/     # Demo .NET app
│   └── dotnetsdk/       # .NET SDK (ARM64 only)
├── savedconfigs/        # Defconfig files per arch
│   ├── arm64/           # br2.defconfig + linux.defconfig
│   └── arm/             # br2.defconfig + linux.defconfig
├── scripts/             # QEMU launchers, release scripts
├── overlay/             # Rootfs overlay (e.g., .profile)
├── tools/build-env/     # Docker/Podman container build
└── documents/           # 12 English docs + tracking/
```

### Package Pattern (Buildroot .mk convention)
```
package/<name>/
├── Config.in        # Buildroot menu configuration
├── <name>.mk        # Package definition (version, source, build/install cmds)
├── config_<name>.sh # Configure step (called from .mk)
├── build_<name>.sh  # Build step (called from .mk)
└── install_<name>.sh # Install step (called from .mk)
```

### Container Build Workflow
```
./tools/build-env/run.sh --build           # Build container image
./tools/build-env/run.sh -- make defconfig # Configure Buildroot
./tools/build-env/run.sh -- make            # Build everything
```

Mounts:
- `$BUILDROOT_DIR` → `/work/buildroot`
- `$FOURDOTNET_ROOT` → `/work/4dotnet`
- `HOME=/work` inside container

## Key Conventions

### Commit Message Format
`type(scope): description` — e.g., `feat(lldb): upgrade to llvm-project main branch`

### Patch Management
- Source modifications go through Buildroot patch system
- Patches stored in `package/<name>/mypatches/`
- Modified source files in `package/<name>/modified/`
- **Never edit source directly** — use patches

### Documentation
- English docs: `documents/*.md`
- Chinese docs: `documents/zh/*.md` (mirrors English structure)
- Tracking: `documents/tracking/`
- Chat logs: `documents/chat/chat-[YYYYMMDD]-00[n].md`

## Current Development State

### Completed
- [x] Containerized build environment (Docker/Podman, Ubuntu 24.04)
- [x] LLDB 17.0.6 + .NET Runtime v8.0.0 building
- [x] ARM64 SOS plugin debugging works
- [x] Container build documentation

### In Progress (This Plan)
- [ ] BMAD Method framework installation
- [ ] Chat tracking infrastructure
- [ ] Test infrastructure scaffold
- [ ] Chinese documentation

### Next (from documents/tracking/next-steps.md)
1. Smoke test container workflow
2. Improve container workflow (persistent caches)
3. Modular GitHub Release redesign
4. CI integration (GitHub Actions)
5. Release process simplification

### Known Issues
- ARM illegal instruction (SIGILL) on dotnethello — workaround exists
- SOS only confirmed on ARM64 (ARM support commented out)
- symstore package archived/disabled (moved into diagnostics repo)

## Development Frameworks Active

| Framework | Role |
|-----------|------|
| **Superpowers** | Development discipline (TDD, debugging, code review, plan writing) |
| **BMAD Method** | Overall methodology (4-phase Agile AI-driven development) |

## Git Repository
- **Remote**: `https://github.com/oldzhu/4dotnet.git`
- **Buildroot companion**: `https://github.com/oldzhu/buildroot.git` (sibling directory)
