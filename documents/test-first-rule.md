# Test-First Rule for 4dotnet

> **中文版**: [documents/zh/test-first-rule.md](zh/test-first-rule.md)

## Principle
**Every deliverable must have tests defined BEFORE implementation begins.**

Tests = automated verification with PASS/FAIL/SKIP results, evidence saved.

## Test Categories

| Category | When to Run | Examples |
|----------|-----------|----------|
| **Build Tests** | After any package change | defconfig succeeds, make exits 0, binaries produced |
| **Boot Tests** | After a successful build | VM boots, kernel loads, login prompt appears |
| **Debug Tests** | After boot verified | LLDB launches, SOS loads, breakpoints work |
| **Container Tests** | After container workflow changes | Image builds, caches persist, defconfig works inside |

## Test Execution
```bash
# Run all tests
bash scripts/test/run-tests.sh

# Run specific test
bash scripts/test/test-build-arm64.sh
```

## Adding New Tests
1. Define what you're testing and expected outcome
2. Write test script in `scripts/test/test-<name>.sh`
3. Source `common.sh` for helpers
4. Test must: PASS (success), FAIL (error), or SKIP (not applicable)
5. Save evidence to `.sisyphus/evidence/`

## Full Debugging Scenario Tests
For each debugging path in the project, define end-to-end scenario tests:

### Scenario 1: .NET App Debugging (LLDB + SOS)
1. Build VM with LLDB + SOS + dotnethello
2. Boot VM → Login
3. LLDB launch dotnethello → `r`
4. SIGSTOP → `clrstack` → `dumpheap` → `dumpobj`
5. Verify managed debugging works

### Scenario 2: Kernel Debugging (GDB)
1. Build VM with vmlinux
2. Start VM with `-s -S`
3. GDB connect → set breakpoint → continue
4. Verify kernel debugging works

### Scenario 3: Host QEMU Debugging (GDB)
1. Start VM normally
2. GDB attach to QEMU process
3. Set breakpoint in QEMU code → continue
4. Verify host-side debugging works

### Scenario 4: Container Build
1. Build container image
2. Configure defconfig inside container
3. Start build, verify downloads begin
4. Verify cache persistence across rebuilds
