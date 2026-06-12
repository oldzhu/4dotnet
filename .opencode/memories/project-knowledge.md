# 4dotnet — Project Knowledge

## Identity
4dotnet is a Buildroot external tree that builds ARM/ARM64 Linux VMs for .NET Core full-stack debugging.

## Architecture
```
QEMU → Linux Kernel → LLDB/GDB → SOS Plugin → .NET Runtime
```

## Key Directories
| Path | Purpose |
|------|---------|
| `package/` | Buildroot package definitions (.mk, Config.in, build scripts) |
| `savedconfigs/` | Pre-built defconfig files (arm64/, arm/) |
| `scripts/` | QEMU launchers, release scripts, test framework |
| `tools/build-env/` | Docker/Podman container build environment |
| `documents/` | English docs, Chinese docs (zh/), tracking, chat logs |
| `.bmad-output/` | BMAD project context |
| `.opencode/` | Agent skills, memories, and configuration |
| `.sisyphus/` | Work plans, evidence, boulder state |

## Key Commands
```bash
# Configure ARM64
cd ~/buildroot
make BR2_EXTERNAL=~/4dotnet defconfig BR2_DEFCONFIG=~/4dotnet/savedconfigs/arm64/br2.defconfig

# Build
export PATH=$(echo $PATH | tr -d ' ')
make

# Run tests
cd ~/4dotnet && bash scripts/test/run-tests.sh

# Start VM (after build)
~/4dotnet/scripts/arm64/start-qemu.sh
```

## Conventions
- **Commits**: `type(scope): description` (e.g., `feat(lldb): upgrade to main`)
- **Documentation**: EN in `documents/`, ZH in `documents/zh/`
- **Test-first**: Define test cases before implementation
- **Patch management**: Use Buildroot patch system, never edit source directly
- **PATH fix**: Always `export PATH=$(echo $PATH | tr -d ' ')` before `make`

## Current Component Versions
- LLDB: `origin/main` (git, default)
- .NET Runtime: `origin/main` (git, default)
- Binutils: 2.45.1
- GCC: 15.x
- Linux kernel: 6.0.x (customizable)
- QEMU: 7.1.0
