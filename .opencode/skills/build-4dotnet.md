# Skill: build-4dotnet

## Trigger
User asks about building, configuring, or compiling the 4dotnet ARM/ARM64 VM.

## Purpose
Guide the user through building the 4dotnet debugging VM — from configuration to running the final image.

## Prerequisites Check
Before building, verify:
1. Buildroot exists at `~/buildroot` (git clone if not)
2. 4dotnet exists at `~/4dotnet` (already cloned)
3. Docker or Podman available (for container builds) OR Buildroot host deps installed

## Build Steps

### Option A: Container Build (Recommended — No host deps needed)
```bash
# 1. Build container image (one-time)
cd ~/4dotnet
BUILD_NETWORK=host ./tools/build-env/run.sh --build

# 2. Configure for ARM64
export PATH=$(echo $PATH | tr -d ' ')
./tools/build-env/run.sh -- make distclean
./tools/build-env/run.sh -- make BR2_EXTERNAL=/work/4dotnet defconfig \
  BR2_DEFCONFIG=/work/4dotnet/savedconfigs/arm64/br2.defconfig

# 3. (Optional) Enable ccache for faster rebuilds
echo 'BR2_CCACHE=y' >> ~/buildroot/.config
echo 'BR2_CCACHE_DIR="/work/.ccache"' >> ~/buildroot/.config
make olddefconfig

# 4. Build (4-8 hours)
./tools/build-env/run.sh -- make
```

### Option B: Local Build (Faster, requires host deps)
```bash
# 1. Configure
cd ~/buildroot
export PATH=$(echo $PATH | tr -d ' ')
make distclean
make BR2_EXTERNAL=~/4dotnet defconfig \
  BR2_DEFCONFIG=~/4dotnet/savedconfigs/arm64/br2.defconfig

# 2. Enable ccache (optional)
echo 'BR2_CCACHE=y' >> .config && make olddefconfig

# 3. Build
make
```

## Common Errors

### "Your PATH contains spaces"
```bash
export PATH=$(echo $PATH | tr -d ' ')
```

### Build hangs on Kconfig prompts
```bash
make olddefconfig  # Auto-resolves new config options
```

### "cannot attach stdin to a TTY-enabled container"
Fixed in latest `tools/build-env/run.sh` — auto-detects TTY. If still happening, the container wrapper handles it.

### "rm: cannot remove dl/ Device or resource busy"
Harmless — dl/ is a persistent cache mount. Ignore and continue.

## After Build
```bash
# Start the VM
~/4dotnet/scripts/arm64/start-qemu.sh

# Login as root (no password)
# Run the demo
lldb dotnethello/dotnethello
(lldb) r
```

## Version Selection
To choose component versions:
```bash
make menuconfig
# Navigate to: Toolchain → GCC version / Binutils version
# Navigate to: Target packages → LLDB → source (git/tarball)
# Navigate to: Target packages → dotnetruntime → source (git/tarball)
```

Pre-built configs:
- `savedconfigs/arm64/br2.defconfig` — Default (stable toolchain, LLDB/NET=main)
- `savedconfigs/arm64/br2.defconfig.latest` — Everything latest

## Troubleshooting
If build fails:
1. Check `documents/tracking/build-{date}.log` for errors
2. Check `documents/tracking/progress-{date}.md` for known issues and fixes
3. Check `.opencode/memories/known-issues.md` for documented problems
4. Common: network issues → use `BUILD_NETWORK=host`
5. Common: proxy issues → set `http_proxy` / `https_proxy`
