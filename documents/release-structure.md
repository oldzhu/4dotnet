# Modular GitHub Release Structure

> **中文版**: [documents/zh/release-structure.md](zh/release-structure.md)

## Overview

4dotnet releases are modular — a small base VM with optional add-on packs for debugging needs.

## Artifact Layout

### Base VM (Always Required)
| File | Description | Size (approx) |
|------|-------------|---------------|
| `4dotnet-arm64-base-[date].tar.xz` | Bootable ARM64 VM + LLDB + GDB | ~200MB |
| `4dotnet-arm-base-[date].tar.xz` | Bootable ARM VM + LLDB + GDB | ~200MB |

Contains:
- Linux kernel (Image/zImage)
- Root filesystem (rootfs.ext4)
- LLDB debugger
- GDB debugger
- QEMU launch scripts
- SSH server (optional)

### .NET Debugging Pack (Optional)
| File | Description |
|------|-------------|
| `4dotnet-arm64-debug-pack-[date].tar.xz` | SOS plugin + runtime/native symbols |
| `4dotnet-arm-debug-pack-[date].tar.xz` | SOS plugin + runtime/native symbols |

Contains:
- SOS LLDB plugin
- .NET runtime (libcoreclr.so, libhostfxr.so, etc.)
- dotnethello demo application
- Native debug symbols

### Kernel Debug Pack (Optional)
| File | Description |
|------|-------------|
| `4dotnet-arm64-kernel-debug-[date].tar.xz` | vmlinux + kernel debug symbols |
| `4dotnet-arm-kernel-debug-[date].tar.xz` | vmlinux + kernel debug symbols |

### Full Release (Convenience)
| File | Description |
|------|-------------|
| `4dotnet-arm64-full-[date].tar.xz` | Everything combined |

## Installation

### Minimal Setup (Base VM only)
```bash
tar -xvf 4dotnet-arm64-base-[date].tar.xz
cd 4dotnet-arm64
./start-qemu.sh
```

### Add .NET Debugging
```bash
# After extracting base VM
tar -xvf 4dotnet-arm64-debug-pack-[date].tar.xz -C 4dotnet-arm64/
```

## Release Script

Use `scripts/release-modular.sh` to create modular releases:
```bash
# Dry run (preview)
bash scripts/release-modular.sh --dry-run arm64

# Create modular release
bash scripts/release-modular.sh arm64

# Create full combined release
bash scripts/release-modular.sh --full arm64
```
