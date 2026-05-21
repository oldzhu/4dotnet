# 4dotnet Continuation — Development, Maintenance & Test Plan

## TL;DR

> **Quick Summary**: Continue 4dotnet development by completing the 5 tracked next-steps (smoke test → container workflow → modular release → CI → release simplification), upgrading LLDB and .NET runtime to main branches, establishing test infrastructure, installing BMAD Method framework, and creating bilingual (Chinese/English) documentation.
>
> **Deliverables**:
> - Verified container build workflow (smoke tested)
> - Improved container build with persistent caches (dl/, ccache)
> - Modular GitHub Release (Base VM + optional debug packs)
> - GitHub Actions CI pipeline
> - One-click release script
> - LLDB package updated to llvm-project main branch
> - .NET runtime package updated to dotnet/runtime main branch
> - Test infrastructure (build verification + VM boot smoke tests + CI)
> - Chinese documentation for all existing English docs
> - BMAD Method installed with project context
> - Chat tracking infrastructure (documents/chat/)
>
> **Estimated Effort**: Large
> **Parallel Execution**: YES — 5 waves
> **Critical Path**: BMAD Setup → Smoke Test → Container Workflow → Modular Release → CI → Release Script

---

## Context

### Original Request
User wants to continue 4dotnet project development/maintenance/testing, apply best development frameworks (Superpowers + BMAD Method), maintain bilingual Chinese/English documentation for all activities, and save chat interactions to documents/chat/.

### Interview Summary
**Key Discussions**:
- **Priorities**: Complete all 5 next-steps tasks + upgrade LLDB/dotnet to main branches + establish test infrastructure + bilingual docs
- **Framework**: Superpowers (development skills) + BMAD Method (methodology/process)
- **Documentation**: Separate Chinese and English files (分别维护)
- **Test Strategy**: Yes — establish test infrastructure for this Buildroot build system
- **Component Upgrades**: LLDB → llvm-project main, .NET Runtime → dotnet/runtime main (latest dev branches)
- **BMAD**: Install and initialize as part of the plan
- **No new features**: Scope limited to existing next-steps + upgrades + tests + docs

**Research Findings**:
- Project is a Buildroot external tree (NOT typical software) — 8 packages, containerized build
- BMAD Method: 4-phase AI agile framework, specialized agents, Test Architect module
- No existing test infrastructure (only manual shell scripts: test.sh, test01.sh)
- Current LLDB: v17.0.6 (tarball), .NET Runtime: v8.0.0 (tarball)
- Known ARM illegal instruction issue with workaround/patch
- All existing docs are English only (12 markdown files + tracking/)

### Metis Review
Metis timed out — self-performed gap analysis instead.

**Identified Gaps** (self-addressed):
1. **Buildroot-specific test design**: Tests must verify build success, VM boot, and debugging — not code-level unit tests. Addressed via custom test strategy.
2. **Main branch risk**: Using main/dev branches means builds may break unexpectedly. Addressed via version pinning and CI monitoring.
3. **BMAD + Buildroot mismatch**: BMAD expects typical software projects. Addressed by adapting BMAD workflows for build system context.
4. **Chat file creation**: Prometheus cannot write to documents/chat/ (md-only constraint). Addressed by delegating to executor agent.
5. **ARM illegal instruction**: Existing workaround documented. POC patch exists. Must verify upgrades don't reintroduce the issue.

---

## Work Objectives

### Core Objective
Advance the 4dotnet Buildroot project from its current state to a modular, CI-verified, well-documented build system with upgraded components and established testing infrastructure.

### Concrete Deliverables
- `documents/chat/` directory with chat tracking infrastructure
- BMAD Method installed + `.bmad-output/project-context.md`
- Smoke test report for container build workflow
- Updated `tools/build-env/run.sh` with persistent cache mounts
- Modular GitHub Release design doc + implementation
- `.github/workflows/ci.yml` for automated build verification
- One-click release script (`scripts/release.sh`)
- Updated LLDB package (main branch, Config.in + .mk + patches)
- Updated .NET runtime package (main branch, Config.in + .mk + patches)
- Test infrastructure scripts (`scripts/test/`)
- Chinese documentation (12 files mirroring English docs)
- Updated English docs reflecting new workflows

### Definition of Done
- [ ] Container build succeeds for both arm64 and arm defconfigs
- [ ] `make` completes without errors for arm64 target
- [ ] QEMU VM boots and dotnethello runs successfully
- [ ] LLDB + SOS debugging works on arm64 VM
- [ ] GitHub Actions CI passes on push
- [ ] Modular release artifacts are downloadable and functional
- [x] All existing English docs have Chinese counterparts
- [x] BMAD project-context.md exists and is accurate
- [ ] All chat interactions saved to documents/chat/

### Must Have
- Working container build for both arm and arm64
- Upgraded LLDB and .NET runtime packages that build successfully
- CI pipeline that verifies builds
- Chinese documentation for all major docs
- Modular release structure (Base VM + optional packs)

### Must NOT Have (Guardrails)
- NO breaking the existing "download and run" experience
- NO removing arm (32-bit) support — both arm and arm64 must work
- NO over-engineering: keep Buildroot patterns simple, minimize abstraction
- NO AI slop: no excessive comments, no premature abstraction, no over-validation
- NO silent failures: all build/test failures must produce clear error messages
- NO editing source packages directly — use patches via Buildroot convention
- NO force-pushing to main branch without explicit user approval

---

## Verification Strategy

> **ZERO HUMAN INTERVENTION** — ALL verification is agent-executed. No exceptions.

### Test Decision
- **Infrastructure exists**: NO — must be established from scratch
- **Automated tests**: YES (tests-after for build system verification)
- **Framework**: Custom shell-script based verification + GitHub Actions CI
- **Test types**: Build success verification, VM boot smoke tests, debugging capability tests, container build tests

### QA Policy
Every task MUST include agent-executed QA scenarios.
Evidence saved to `.sisyphus/evidence/task-{N}-{scenario-slug}.{ext}`.

- **Build verification**: Use Bash — Run `make`, capture output, check exit code
- **VM boot test**: Use Bash (QEMU) — Start VM, check for login prompt, run dotnethello
- **Container test**: Use Bash (Docker/Podman) — Build image, run build, verify output
- **API/GitHub**: Use Bash (curl/gh) — Check releases, verify CI status

---

## Execution Strategy

### Parallel Execution Waves

```
Wave 1 (Start Immediately — foundation + scaffolding):
├── Task 1: BMAD Method installation + project context [quick]
├── Task 2: Chat tracking infrastructure (documents/chat/) [quick]
├── Task 3: Test infrastructure scaffold [quick]
└── Task 4: Chinese documentation template + first doc [quick]

Wave 2 (After Wave 1 — core dev, MAX PARALLEL):
├── Task 5: Upgrade LLDB package to llvm-project main branch [deep]
├── Task 6: Upgrade .NET runtime package to dotnet/runtime main branch [deep]
├── Task 7: Smoke test container build workflow [quick]
├── Task 8: Improve container build workflow (persistent caches) [unspecified-high]
└── Task 9: Chinese docs batch 1 (build, download, publish docs) [writing]

Wave 3 (After Wave 2 — integration):
├── Task 10: Modular GitHub Release redesign + implementation [deep]
├── Task 11: GitHub Actions CI pipeline [unspecified-high]
├── Task 12: Build verification tests (arm64 + arm) [quick]
└── Task 13: Chinese docs batch 2 (debug docs) [writing]

Wave 4 (After Wave 3 — polish + final):
├── Task 14: Release process simplification (one-click script) [quick]
├── Task 15: VM boot + debugging smoke tests [unspecified-high]
├── Task 16: Container build verification tests [quick]
└── Task 17: Chinese docs batch 3 (remaining + README) [writing]

Wave FINAL (After ALL tasks — 4 parallel reviews):
├── Task F1: Plan compliance audit (oracle)
├── Task F2: Code quality review (unspecified-high)
├── Task F3: Real manual QA (unspecified-high)
└── Task F4: Scope fidelity check (deep)
-> Present results -> Get explicit user okay
```

**Critical Path**: Task 1 → Task 7 → Task 8 → Task 10 → Task 11 → Task 14 → F1-F4
**Parallel Speedup**: ~60% faster than sequential
**Max Concurrent**: 5 (Waves 2 & 3)

### Dependency Matrix
- **1-4**: — — 5-9, None
- **5**: — — 10, 12, 15, 1
- **6**: — — 10, 12, 15, 1
- **7**: 1 — 8, 1
- **8**: 7 — 10, 11, 16, 2
- **9**: 1 — —, 1
- **10**: 5, 6, 8 — 11, 14, 3
- **11**: 8, 10 — 12, 13, 16, 3
- **12**: 5, 6, 11 — 15, 3
- **13**: 1 — —, 1
- **14**: 10 — 15, 3
- **15**: 5, 6, 12, 14 — FINAL, 3
- **16**: 8, 11 — FINAL, 3
- **17**: 1 — FINAL, 1

### Agent Dispatch Summary
- **Wave 1**: 4 tasks — T1→quick, T2→quick, T3→quick, T4→writing
- **Wave 2**: 5 tasks — T5→deep, T6→deep, T7→quick, T8→unspecified-high, T9→writing
- **Wave 3**: 4 tasks — T10→deep, T11→unspecified-high, T12→quick, T13→writing
- **Wave 4**: 4 tasks — T14→quick, T15→unspecified-high, T16→quick, T17→writing
- **FINAL**: 4 tasks — F1→oracle, F2→unspecified-high, F3→unspecified-high, F4→deep

---

## TODOs

> Implementation + Test = ONE Task. Never separate.
> EVERY task MUST have: Recommended Agent Profile + Parallelization info + QA Scenarios.

- [x] 1. **BMAD Method Installation + Project Context**

  **What to do**:
  - Install BMAD Method framework into the 4dotnet project
  - Run BMAD installation/bootstrap following official docs (https://docs.bmad-method.org/)
  - Create `.bmad-output/project-context.md` with:
    - Technology stack: Buildroot external tree, LLVM/LLDB, .NET Runtime, Docker/Podman, QEMU
    - Target architectures: ARM (armv7) + ARM64 (aarch64)
    - Build system: Buildroot with external tree pattern
    - Key conventions: .mk package files, Config.in, shell build scripts
  - Create `.bmad-output/` directory structure
  - Verify BMAD agents are accessible (test with `bmad-help` or equivalent)

  **Must NOT do**:
  - Do NOT modify any existing build files during BMAD setup
  - Do NOT install BMAD modules that aren't needed (skip Game Dev Studio, CIS unless explicitly needed)
  - Do NOT run any BMAD workflows that would modify project files yet — installation only

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Installation and configuration task following documentation
  - **Skills**: [`using-superpowers`]
    - `using-superpowers`: General skill framework awareness for setup

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 2, 3, 4)
  - **Blocks**: Tasks 7 (smoke test needs BMAD context)
  - **Blocked By**: None (can start immediately)

  **References**:
  - BMAD Method Docs: `https://docs.bmad-method.org/` — Installation and setup guides
  - BMAD GitHub: `https://github.com/bmad-code-org/BMAD-METHOD` — README and installation instructions
  - `README.md` — Project overview for project-context.md (goals, architecture, components)
  - `external.mk` — Buildroot external tree pattern for project-context.md
  - `Config.in` — Package registration for project-context.md

  **Acceptance Criteria**:
  - [ ] `.bmad-output/` directory exists
  - [ ] `.bmad-output/project-context.md` exists with accurate project information
  - [ ] BMAD CLI commands respond (e.g., `bmad-help` or BMAD agent invocation)

  **QA Scenarios**:
  ```
  Scenario: BMAD installation verification
    Tool: Bash
    Preconditions: Project directory exists, internet access for BMAD installation
    Steps:
      1. Run: ls -la .bmad-output/
      2. Assert: Directory exists and contains project-context.md
      3. Run: cat .bmad-output/project-context.md
      4. Assert: Contains "Buildroot", "LLDB", ".NET Runtime", "ARM64" key terms
    Expected Result: BMAD project context file accurately describes 4dotnet project
    Failure Indicators: Missing .bmad-output/ directory, empty or inaccurate project-context.md
    Evidence: .sisyphus/evidence/task-1-bmad-install.txt
  ```

  **Commit**: YES (groups with Wave 1)
  - Message: `chore(bmad): install BMAD Method framework and project context`
  - Files: `.bmad-output/`

- [x] 2. **Chat Tracking Infrastructure (documents/chat/)**

  **What to do**:
  - Create `documents/chat/` directory
  - Create `documents/chat/README.md` explaining the chat tracking system (bilingual: Chinese + English)
  - Create the first chat file: `documents/chat/chat-20260512-001.md` with the current session's content
  - Set up `.gitkeep` or initial structure for future chat files
  - The chat README should document:
    - File naming convention: `chat-[YYYYMMDD]-00[n].md`
    - Purpose: Track all AI assistant interactions for reference
    - Both Chinese and English explanation

  **Must NOT do**:
  - Do NOT create chat files for imaginary/future conversations — only real interactions
  - Do NOT modify any build files

  **Recommended Agent Profile**:
  - **Category**: `writing`
    - Reason: Documentation creation with bilingual requirement
  - **Skills**: []
    - No specific skills needed — straightforward file creation

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 1, 3, 4)
  - **Blocks**: None directly (supporting infrastructure)
  - **Blocked By**: None (can start immediately)

  **References**:
  - `documents/` — Existing docs directory structure (model for organization)
  - `documents/tracking/next-steps.md` — Example of tracking document format
  - `README.md` — Project overview for README content

  **Acceptance Criteria**:
  - [ ] `documents/chat/` directory exists
  - [ ] `documents/chat/README.md` exists with bilingual explanation
  - [ ] `documents/chat/chat-20260512-001.md` exists with accurate session content

  **QA Scenarios**:
  ```
  Scenario: Chat infrastructure verification
    Tool: Bash
    Preconditions: None
    Steps:
      1. Run: ls documents/chat/
      2. Assert: README.md exists, at least one chat-*.md file exists
      3. Run: head -20 documents/chat/chat-20260512-001.md
      4. Assert: Contains "2026-05-12", "Prometheus", "4dotnet"
      5. Run: grep -c "中文\|Chinese" documents/chat/README.md
      6. Assert: At least 1 match (bilingual content present)
    Expected Result: Chat tracking infrastructure properly set up with bilingual README and first chat file
    Failure Indicators: Missing directory, missing files, monolingual README
    Evidence: .sisyphus/evidence/task-2-chat-infra.txt
  ```

  **Commit**: YES (groups with Wave 1)
  - Message: `docs(chat): establish chat tracking infrastructure with bilingual README`
  - Files: `documents/chat/`

- [x] 3. **Test Infrastructure Scaffold**

  **What to do**:
  - Create `scripts/test/` directory
  - Create test framework skeleton: `scripts/test/run-tests.sh` (orchestrator)
  - Create test helper: `scripts/test/common.sh` with shared functions (log, assert, cleanup)
  - Create placeholder test files:
    - `scripts/test/test-build-arm64.sh`
    - `scripts/test/test-build-arm.sh`
    - `scripts/test/test-vm-boot-arm64.sh`
    - `scripts/test/test-vm-boot-arm.sh`
    - `scripts/test/test-container-build.sh`
  - Each placeholder: shebang + source common.sh + echo "TODO: implement" + exit 0
  - Create `scripts/test/README.md` (bilingual) documenting test framework usage
  - Test that run-tests.sh executes successfully (even with placeholder tests)

  **Must NOT do**:
  - Do NOT implement actual test logic yet — scaffold only
  - Do NOT modify Buildroot build files

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Shell script scaffolding with clear structure
  - **Skills**: []
    - No specific skills needed

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 1, 2, 4)
  - **Blocks**: Tasks 12, 15, 16 (test implementation depends on scaffold)
  - **Blocked By**: None (can start immediately)

  **References**:
  - `scripts/build_debug_hostqemu.sh` — Example of existing shell script patterns (shebang, pushd/popd, sed usage)
  - `scripts/pub2img.sh` — Another shell script example for style reference
  - `scripts/test.sh` — Existing manual test script (reference for test patterns)
  - `scripts/test01.sh` — Existing manual test script (reference for test patterns)

  **Acceptance Criteria**:
  - [ ] `scripts/test/` directory exists
  - [ ] `scripts/test/run-tests.sh` is executable and runs without error
  - [ ] `scripts/test/README.md` exists with bilingual content
  - [ ] All 5 placeholder test files exist and are executable

  **QA Scenarios**:
  ```
  Scenario: Test framework scaffold verification
    Tool: Bash
    Preconditions: None
    Steps:
      1. Run: ls scripts/test/
      2. Assert: run-tests.sh, common.sh, README.md, 5 test-*.sh files exist
      3. Run: bash scripts/test/run-tests.sh
      4. Assert: Exit code 0, output shows tests ran (even if TODO placeholders)
      5. Run: test -x scripts/test/run-tests.sh && echo "executable"
      6. Assert: Output is "executable"
    Expected Result: Test framework scaffold executes placeholder tests successfully
    Failure Indicators: Missing files, non-executable, run-tests.sh fails
    Evidence: .sisyphus/evidence/task-3-test-scaffold.txt
  ```

  **Commit**: YES (groups with Wave 1)
  - Message: `test(infra): scaffold test framework with placeholder test files`
  - Files: `scripts/test/`

- [x] 4. **Chinese Documentation Template + First Doc**

  **What to do**:
  - Create `documents/zh/` directory for Chinese documents
  - Create `documents/zh/README.md` — Chinese version of project README
  - Translate the core README.md to Chinese (markdown format preserved)
  - Create documentation template `documents/zh/TEMPLATE.md` with:
    - Standard header format (title, date, author, status)
    - Section conventions (## for sections, ### for subsections)
    - Bilingual note format conventions
    - Code block conventions
  - Update root `README.md` to link to `documents/zh/` for Chinese readers

  **Must NOT do**:
  - Do NOT translate code examples — keep code as-is
  - Do NOT change the meaning or structure of the original README
  - Do NOT remove any existing English content

  **Recommended Agent Profile**:
  - **Category**: `writing`
    - Reason: Translation and documentation creation
  - **Skills**: []
    - No specific skills needed — bilingual writing task

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 1, 2, 3)
  - **Blocks**: Tasks 9, 13, 17 (subsequent Chinese doc translations)
  - **Blocked By**: None (can start immediately)

  **References**:
  - `README.md` — Source content for Chinese translation
  - `documents/build.md` — Example doc structure to model template after
  - `documents/tracking/next-steps.md` — Example of structured tracking doc

  **Acceptance Criteria**:
  - [ ] `documents/zh/` directory exists
  - [ ] `documents/zh/README.md` is a complete, accurate Chinese translation of root README.md
  - [ ] `documents/zh/TEMPLATE.md` exists with documentation conventions
  - [ ] Root `README.md` has a link to Chinese docs (e.g., "中文文档: documents/zh/")

  **QA Scenarios**:
  ```
  Scenario: Chinese documentation setup verification
    Tool: Bash
    Preconditions: None
    Steps:
      1. Run: ls documents/zh/
      2. Assert: README.md and TEMPLATE.md exist
      3. Run: wc -l documents/zh/README.md
      4. Assert: Line count >= 30 (substantial translation)
      5. Run: grep "中文" README.md || grep "Chinese" README.md
      6. Assert: Root README references Chinese docs
    Expected Result: Chinese documentation directory set up with translated README and template
    Failure Indicators: Empty or very short translation, missing template, no cross-reference in root README
    Evidence: .sisyphus/evidence/task-4-zh-docs.txt
  ```

  **Commit**: YES (groups with Wave 1)
  - Message: `docs(zh): establish Chinese documentation structure with README translation`
  - Files: `documents/zh/`, `README.md`

- [x] 5. **Upgrade LLDB Package to llvm-project Main Branch**

  **What to do**:
  - Read current LLDB package files: `package/lldb/Config.in`, `package/lldb/lldb.mk`
  - Change default source from tarball (llvmorg-17.0.6) to git repo (origin/main)
  - Update `Config.in`:
    - Change default choice from `BR2_PACKAGE_LLDB_CUSTOM_TARBALL` to `BR2_PACKAGE_LLDB_CUSTOM_GIT`
    - Update default repo URL: `https://github.com/llvm/llvm-project.git`
    - Update default version: `origin/main`
    - Update tarball fallback URL to latest tag (for reference)
  - Update `lldb.mk`:
    - Verify git source method is properly configured
    - Ensure `LLDB_SUBDIR=llvm` is correct (main branch structure unchanged)
    - Ensure cmake options (`-DLLVM_ENABLE_PROJECTS=clang;lldb;lld`) are still valid for main
    - Check for any deprecated cmake options that need updating
  - Review and update any patches in `package/lldb/v*/` directories:
    - Create `package/lldb/v-main/` directory
    - Copy relevant patches, test if they still apply
    - If patches fail, create updated versions
  - Update LLDB version directory references if needed
  - Document changes in commit message

  **Must NOT do**:
  - Do NOT remove existing version directories (v15.0.2 through v17.0.6) — keep as fallback
  - Do NOT change the package name or registration in Config.in root
  - Do NOT modify the actual llvm-project source — only package definition files

  **Recommended Agent Profile**:
  - **Category**: `deep`
    - Reason: Requires understanding Buildroot package system + LLVM build system + cmake option compatibility checking
  - **Skills**: [`using-superpowers`]
    - `using-superpowers`: Framework awareness for structured approach

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Task 6 — different packages)
  - **Parallel Group**: Wave 2 (with Tasks 6, 7, 8, 9)
  - **Blocks**: Tasks 10 (modular release), 12 (build tests), 15 (VM tests)
  - **Blocked By**: None (can start immediately after Wave 1)

  **References**:
  - `package/lldb/lldb.mk` — Current LLDB package definition (to modify)
  - `package/lldb/Config.in` — Current LLDB configuration (to modify)
  - `package/lldb/v17.0.6/` — Latest existing version (reference patches and build scripts)
  - `package/lldb/v16.0.6/`, `v15.0.7/` — Older versions for pattern reference
  - LLVM Project GitHub: `https://github.com/llvm/llvm-project` — Main branch reference
  - LLVM CMake docs: Check for deprecated options in main branch

  **Acceptance Criteria**:
  - [ ] `Config.in` default changed to `BR2_PACKAGE_LLDB_CUSTOM_GIT` with `origin/main`
  - [ ] `lldb.mk` references correct git repo and version
  - [ ] `package/lldb/v-main/` directory created if patches need updating
  - [ ] Package definition is syntactically valid (Buildroot can parse it)

  **QA Scenarios**:
  ```
  Scenario: LLDB package configuration validation
    Tool: Bash
    Preconditions: Buildroot installed at ~/buildroot, 4dotnet at ~/4dotnet
    Steps:
      1. Run: cd ~/buildroot && make BR2_EXTERNAL=~/4dotnet defconfig BR2_DEFCONFIG=~/4dotnet/savedconfigs/arm64/br2.defconfig
      2. Assert: defconfig succeeds (exit 0, no errors about LLDB)
      3. Run: grep "BR2_PACKAGE_LLDB_CUSTOM_GIT=y" ~/buildroot/.config
      4. Assert: LLDB git source is selected
      5. Run: make lldb-source 2>&1 | tail -20
      6. Assert: Source download/clone starts (may timeout — accept "Cloning" or "Fetching" in output)
    Expected Result: Buildroot configures LLDB from git main branch without errors
    Failure Indicators: defconfig fails, git repo not found, cmake option errors
    Evidence: .sisyphus/evidence/task-5-lldb-upgrade.txt

  Scenario: Verify old tarball source still works as fallback
    Tool: Bash
    Preconditions: Same as above
    Steps:
      1. Run: make lldb-menuconfig (if interactive config possible) — OR — 
         Verify: Config.in still has BR2_PACKAGE_LLDB_CUSTOM_TARBALL option
      2. Run: grep "BR2_PACKAGE_LLDB_CUSTOM_TARBALL" package/lldb/Config.in
      3. Assert: Tarball option still exists in Config.in (not removed)
    Expected Result: Tarball fallback option remains available
    Evidence: .sisyphus/evidence/task-5-lldb-fallback.txt
  ```

  **Commit**: YES (groups with Wave 2)
  - Message: `feat(lldb): upgrade default source to llvm-project main branch`
  - Files: `package/lldb/`

- [x] 6. **Upgrade .NET Runtime Package to dotnet/runtime Main Branch**

  **What to do**:
  - Read current dotnetruntime package files: `package/dotnetcore/dotnetruntime/Config.in`, `dotnetruntime.mk`
  - Change default source from tarball (v8.0.0) to git repo (origin/main)
  - Update `Config.in`:
    - Change default choice from `BR2_PACKAGE_DOTNETRUNTIME_CUSTOM_TARBALL` to `BR2_PACKAGE_DOTNETRUNTIME_CUSTOM_GIT`
    - Update default repo URL: `https://github.com/dotnet/runtime.git`
    - Update default version: `origin/main`
  - Update `dotnetruntime.mk`:
    - Verify git source method is properly configured
    - Ensure build scripts (`config_dotnetruntime.sh`, `build_dotnetruntime.sh`) work with main branch
  - Review build scripts for main branch compatibility:
    - Check `build_dotnetruntime.sh` for any version-specific flags or paths
    - Check `config_dotnetruntime.sh` for version assumptions
    - `-subset clr+libs+host+packs` — verify still valid for main
    - Cross-compilation flags — verify compatibility
  - Review patches in `package/dotnetcore/dotnetruntime/mypatches/` — may need updating
  - Review modified files in `package/dotnetcore/dotnetruntime/modified/` — may need updating
  - Update version directories: `v8.0.0/` stays as fallback, note main branch usage

  **Must NOT do**:
  - Do NOT remove `v6.0.10/` or `v8.0.0/` directories — keep as fallback
  - Do NOT modify the actual dotnet/runtime source — only package definition files
  - Do NOT change the `-subset` flag without verifying it exists in main branch

  **Recommended Agent Profile**:
  - **Category**: `deep`
    - Reason: Requires understanding Buildroot package system + .NET build system + cross-compilation + patch management
  - **Skills**: [`using-superpowers`]
    - `using-superpowers`: Framework awareness for structured approach

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Task 5 — different packages)
  - **Parallel Group**: Wave 2 (with Tasks 5, 7, 8, 9)
  - **Blocks**: Tasks 10 (modular release), 12 (build tests), 15 (VM tests)
  - **Blocked By**: None (can start immediately after Wave 1)

  **References**:
  - `package/dotnetcore/dotnetruntime/dotnetruntime.mk` — Current package definition (to modify)
  - `package/dotnetcore/dotnetruntime/Config.in` — Current configuration (to modify)
  - `package/dotnetcore/dotnetruntime/build_dotnetruntime.sh` — Build script (check main branch compatibility)
  - `package/dotnetcore/dotnetruntime/config_dotnetruntime.sh` — Config script (check main branch compatibility)
  - `package/dotnetcore/dotnetruntime/mypatches/` — Existing patches (may need updating)
  - `package/dotnetcore/dotnetruntime/modified/` — Modified source files (may need updating)
  - dotnet/runtime GitHub: `https://github.com/dotnet/runtime` — Main branch reference
  - dotnet/runtime build docs: Check for build.sh changes in main branch

  **Acceptance Criteria**:
  - [ ] `Config.in` default changed to `BR2_PACKAGE_DOTNETRUNTIME_CUSTOM_GIT` with `origin/main`
  - [ ] `dotnetruntime.mk` references correct git repo and version
  - [ ] Build scripts reviewed and updated if needed for main branch compatibility
  - [ ] Patches reviewed — if any fail to apply, noted in commit message

  **QA Scenarios**:
  ```
  Scenario: .NET runtime package configuration validation
    Tool: Bash
    Preconditions: Buildroot installed, LLDB package available
    Steps:
      1. Run: cd ~/buildroot && make BR2_EXTERNAL=~/4dotnet defconfig BR2_DEFCONFIG=~/4dotnet/savedconfigs/arm64/br2.defconfig
      2. Assert: defconfig succeeds (exit 0, no errors about dotnetruntime)
      3. Run: grep "BR2_PACKAGE_DOTNETRUNTIME_CUSTOM_GIT=y" ~/buildroot/.config
      4. Assert: dotnetruntime git source is selected
      5. Run: grep "BR2_PACKAGE_DOTNETRUNTIME=y" ~/buildroot/.config
      6. Assert: Package is enabled in config
    Expected Result: Buildroot configures .NET runtime from git main branch without errors
    Failure Indicators: defconfig fails, missing dependencies, syntax errors in .mk
    Evidence: .sisyphus/evidence/task-6-dotnet-upgrade.txt

  Scenario: Verify build scripts parse correctly
    Tool: Bash
    Preconditions: Source code cloned/extracted
    Steps:
      1. Run: bash -n package/dotnetcore/dotnetruntime/build_dotnetruntime.sh
      2. Assert: No syntax errors (exit 0)
      3. Run: bash -n package/dotnetcore/dotnetruntime/config_dotnetruntime.sh
      4. Assert: No syntax errors (exit 0)
    Expected Result: All build scripts pass syntax check
    Evidence: .sisyphus/evidence/task-6-script-syntax.txt
  ```

  **Commit**: YES (groups with Wave 2)
  - Message: `feat(dotnetruntime): upgrade default source to dotnet/runtime main branch`
  - Files: `package/dotnetcore/dotnetruntime/`

- [x] 7. **Smoke Test Container Build Workflow**

  **What to do**:
  - Execute the smoke test defined in `documents/tracking/next-steps.md` section 1
  - Build container image: `BUILD_NETWORK=host ./tools/build-env/run.sh --build`
  - Configure for arm64: `./tools/build-env/run.sh -- make distclean && ... defconfig`
  - Start build: `./tools/build-env/run.sh -- make`
  - Monitor build until it clearly begins downloading/building (stop before full build)
  - Document results:
    - What succeeded (image build, defconfig, make start)
    - What failed (if any)
    - Missing packages or dependencies
    - Time estimates for full build
  - Write smoke test report to `documents/tracking/smoke-test-report.md`
  - If container build fails, document errors and propose fixes

  **Must NOT do**:
  - Do NOT wait for full build completion (smoke test = verify it starts, not completes)
  - Do NOT modify build files to fix issues — document issues for Task 8

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Following documented procedure, executing commands, documenting results
  - **Skills**: []
    - No specific skills needed — command execution and documentation

  **Parallelization**:
  - **Can Run In Parallel**: NO (needs Docker/Podman — sequential dependency with Task 8)
  - **Parallel Group**: Wave 2 (sequential within wave — can run alongside Tasks 5, 6, 9 which don't need Docker)
  - **Blocks**: Task 8 (container workflow improvements depend on smoke test findings)
  - **Blocked By**: Task 1 (BMAD context helpful but not required)

  **References**:
  - `documents/tracking/next-steps.md` — Steps 1-5 for smoke test procedure
  - `documents/build-container.md` — Container build documentation
  - `tools/build-env/run.sh` — Container run script
  - `tools/build-env/Dockerfile` — Container image definition
  - `savedconfigs/arm64/br2.defconfig` — Target configuration for smoke test

  **Acceptance Criteria**:
  - [ ] Container image builds successfully (or documented failure with details)
  - [ ] `defconfig` step succeeds inside container
  - [ ] `make` starts downloading/building (at minimum)
  - [ ] `documents/tracking/smoke-test-report.md` exists with detailed results

  **QA Scenarios**:
  ```
  Scenario: Container image build verification
    Tool: Bash (Docker/Podman required)
    Preconditions: Docker or Podman installed, BUILDROOT_DIR exists
    Steps:
      1. Run: BUILD_NETWORK=host ./tools/build-env/run.sh --build 2>&1 | tail -20
      2. Assert: Image build completes (look for "Successfully tagged" or podman equivalent)
      3. Run: docker images | grep 4dotnet-build-env || podman images | grep 4dotnet-build-env
      4. Assert: 4dotnet-build-env:local image exists
    Expected Result: Container image builds successfully
    Failure Indicators: Docker/Podman not found, build fails, network errors
    Evidence: .sisyphus/evidence/task-7-image-build.txt

  Scenario: defconfig inside container
    Tool: Bash (interactive_bash for tmux if needed)
    Preconditions: Container image built
    Steps:
      1. Run: ./tools/build-env/run.sh -- make distclean 2>&1
      2. Run: ./tools/build-env/run.sh -- make BR2_EXTERNAL=/work/4dotnet defconfig BR2_DEFCONFIG=/work/4dotnet/savedconfigs/arm64/br2.defconfig 2>&1
      3. Assert: Exit code 0, output contains "configuration written"
    Expected Result: Buildroot configuration succeeds inside container
    Failure Indicators: defconfig fails, BR2_EXTERNAL path not found
    Evidence: .sisyphus/evidence/task-7-defconfig.txt
  ```

  **Commit**: YES (groups with Wave 2)
  - Message: `test(smoke): container build workflow smoke test and report`
  - Files: `documents/tracking/smoke-test-report.md`

- [x] 8. **Improve Container Build Workflow (Persistent Caches)**

  **What to do**:
  - Based on smoke test findings and next-steps.md section 2 requirements:
  - Persist Buildroot `dl/` directory on host:
    - Add volume mount for `$BUILDROOT_DIR/dl` → `/work/buildroot/dl`
    - Ensures source tarballs are not re-downloaded on rebuild
  - Persist Buildroot `output/` directory on host (optional):
    - Add volume mount for `$BUILDROOT_DIR/output` → `/work/buildroot/output`
    - Enables incremental rebuilds
  - Enable ccache for faster rebuilds:
    - Create host ccache directory: `$HOME/.cache/4dotnet-ccache/`
    - Mount as volume: `/work/.ccache`
    - Set `CCACHE_DIR=/work/.ccache` inside container
    - Document how to enable BR2_CCACHE in Buildroot config
  - Update `tools/build-env/run.sh`:
    - Add cache mount logic (conditional, with sensible defaults)
    - Add ccache mount and environment setup
    - Add cleanup helper (`--clean-caches` flag)
  - Update `documents/build-container.md`:
    - Document cache persistence
    - Document ccache setup
    - Document disk space requirements
    - Document cleanup procedures
  - Ensure backward compatibility: old behavior still works if caches not configured

  **Must NOT do**:
  - Do NOT hardcode paths that won't work on other machines
  - Do NOT break the non-cached workflow — caches are additive
  - Do NOT mount host paths without checking they exist first

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Shell script modification + Docker/Podman volume management + documentation
  - **Skills**: []
    - No specific skills needed — shell scripting and Docker knowledge

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 5, 6, 9 — independent work)
  - **Parallel Group**: Wave 2 (with Tasks 5, 6, 7, 9)
  - **Blocks**: Tasks 10 (modular release needs container), 11 (CI needs container), 16 (container tests)
  - **Blocked By**: Task 7 (smoke test findings inform improvements)

  **References**:
  - `tools/build-env/run.sh` — Container run script (to modify)
  - `tools/build-env/Dockerfile` — Container image (may not need changes)
  - `documents/build-container.md` — Container docs (to update)
  - `documents/tracking/next-steps.md` — Section 2 requirements
  - `documents/tracking/smoke-test-report.md` — Smoke test findings (from Task 7)
  - Buildroot docs: ccache integration and BR2_CCACHE

  **Acceptance Criteria**:
  - [ ] `run.sh` mounts `dl/` directory persistently
  - [ ] `run.sh` supports ccache (with host directory mount)
  - [ ] `run.sh` has `--clean-caches` option for cleanup
  - [ ] `documents/build-container.md` updated with cache documentation
  - [ ] `run.sh` works without caches (backward compatible)

  **QA Scenarios**:
  ```
  Scenario: Persistent dl/ cache verification
    Tool: Bash
    Preconditions: Container image built, BUILDROOT_DIR/dl exists
    Steps:
      1. Run: ./tools/build-env/run.sh -- ls /work/buildroot/dl/
      2. Assert: Shows contents of BUILDROOT_DIR/dl (not empty container dir)
      3. Run: ./tools/build-env/run.sh -- touch /work/buildroot/dl/.cache-test
      4. Run: ls $BUILDROOT_DIR/dl/.cache-test
      5. Assert: File exists on host (writes from container persist to host)
      6. Cleanup: rm $BUILDROOT_DIR/dl/.cache-test
    Expected Result: dl/ directory is shared between host and container
    Failure Indicators: File not visible on host, mount failed
    Evidence: .sisyphus/evidence/task-8-dl-cache.txt

  Scenario: Ccache configuration verification
    Tool: Bash
    Preconditions: ccache directory exists
    Steps:
      1. Run: mkdir -p $HOME/.cache/4dotnet-ccache
      2. Run: ./tools/build-env/run.sh -- bash -c 'echo $CCACHE_DIR'
      3. Assert: Output is /work/.ccache
    Expected Result: CCACHE_DIR is set inside container
    Evidence: .sisyphus/evidence/task-8-ccache.txt
  ```

  **Commit**: YES (groups with Wave 2)
  - Message: `feat(container): persist build caches (dl/, ccache) for faster rebuilds`
  - Files: `tools/build-env/run.sh`, `documents/build-container.md`

- [x] 9. **Chinese Documentation Batch 1 (Build, Download, Publish Docs)**

  **What to do**:
  - Translate the following English docs to Chinese, placing in `documents/zh/`:
    - `documents/build.md` → `documents/zh/build.md`
    - `documents/build-container.md` → `documents/zh/build-container.md`
    - `documents/download.md` → `documents/zh/download.md`
    - `documents/publish.md` → `documents/zh/publish.md`
  - Follow template from Task 4
  - Preserve all code blocks, commands, and file paths exactly
  - Translate explanatory text, headings, and descriptions
  - Add a note at top of each: "本文档是 [filename] 的中文翻译版 / This is the Chinese translation of [filename]"
  - Link each Chinese doc to its English counterpart and vice versa

  **Must NOT do**:
  - Do NOT modify English originals
  - Do NOT translate code, commands, or file paths
  - Do NOT change command syntax or URLs

  **Recommended Agent Profile**:
  - **Category**: `writing`
    - Reason: Translation work — needs bilingual fluency and attention to technical accuracy
  - **Skills**: []
    - No specific skills needed

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 5, 6, 7, 8 — completely independent)
  - **Parallel Group**: Wave 2 (with Tasks 5, 6, 7, 8)
  - **Blocks**: None directly
  - **Blocked By**: Task 4 (template established)

  **References**:
  - `documents/zh/TEMPLATE.md` — Documentation template (from Task 4)
  - `documents/zh/README.md` — Reference for translation style (from Task 4)
  - `documents/build.md` — Source for Chinese translation
  - `documents/build-container.md` — Source for Chinese translation
  - `documents/download.md` — Source for Chinese translation
  - `documents/publish.md` — Source for Chinese translation

  **Acceptance Criteria**:
  - [ ] 4 Chinese doc files created in `documents/zh/`
  - [ ] Each file contains complete, accurate translation
  - [ ] Code blocks and commands preserved unchanged
  - [ ] Cross-reference links between Chinese and English versions

  **QA Scenarios**:
  ```
  Scenario: Chinese translation completeness verification
    Tool: Bash
    Preconditions: Task 4 completed (documents/zh/ exists)
    Steps:
      1. Run: ls documents/zh/build.md documents/zh/build-container.md documents/zh/download.md documents/zh/publish.md
      2. Assert: All 4 files exist
      3. Run: wc -l documents/zh/build.md
      4. Assert: Line count roughly matches English original (within 20%)
      5. Run: grep -c "~~" documents/zh/build.md
      6. Assert: Code block count matches English original (preserved commands)
    Expected Result: All 4 docs translated with code blocks preserved
    Failure Indicators: Missing files, empty translations, lost code blocks
    Evidence: .sisyphus/evidence/task-9-zh-batch1.txt
  ```

  **Commit**: YES (groups with Wave 2)
  - Message: `docs(zh): translate build, container, download, and publish docs to Chinese`
  - Files: `documents/zh/build.md`, `documents/zh/build-container.md`, `documents/zh/download.md`, `documents/zh/publish.md`

- [x] 10. **Modular GitHub Release Redesign + Implementation**

  **What to do**:
  - Design modular release structure per `documents/tracking/next-steps.md` section 3:
    - **Base VM** (bootable + LLDB + GDB): minimal download, always required
    - **.NET Debugging Pack** (optional): SOS plugin + runtime/native symbols
    - **Kernel Debug Pack** (optional): vmlinux + debug symbols for kernel debugging
  - Define release artifact layout:
    - `4dotnet-arm64-base-[version].tar.xz`
    - `4dotnet-arm64-debug-pack-[version].tar.xz`
    - `4dotnet-arm64-kernel-debug-[version].tar.xz`
    - (same for arm)
  - Update release scripts to produce modular artifacts:
    - Modify `scripts/releasefull.sh` (or create `scripts/release-modular.sh`)
    - Split build output into base + optional packs
  - Update download documentation:
    - `documents/download.md` — document modular download options
    - `documents/zh/download.md` — Chinese version
  - Test: verify base VM boots independently; verify debug pack adds SOS capability
  - Document the modular release structure in `documents/release-structure.md` (bilingual)

  **Must NOT do**:
  - Do NOT break the single-download option — keep a "full" release for convenience
  - Do NOT change the internal VM structure — only how it's packaged for release
  - Do NOT remove GitHub Releases as the distribution channel

  **Recommended Agent Profile**:
  - **Category**: `deep`
    - Reason: Architecture design + shell scripting + documentation + testing — multi-faceted task
  - **Skills**: [`using-superpowers`]
    - `using-superpowers`: Structured approach for design → implementation → verification

  **Parallelization**:
  - **Can Run In Parallel**: NO (depends on component upgrades and container workflow)
  - **Parallel Group**: Wave 3 (with Tasks 11, 12, 13 — but 10 must complete before 11)
  - **Blocks**: Task 11 (CI depends on release structure), Task 14 (release script simplification)
  - **Blocked By**: Tasks 5, 6 (component upgrades), Task 8 (container workflow)

  **References**:
  - `documents/tracking/next-steps.md` — Section 3: Modular GitHub Release redesign requirements
  - `scripts/releasefull.sh` — Existing release script (modify or create new)
  - `scripts/releaseit.sh` — Existing release helper
  - `scripts/pub2img.sh` — Publish to image script (may need modular version)
  - `documents/download.md` — Current download docs (to update)
  - `documents/publish.md` — Publishing docs (may need updates)
  - `scripts/arm64/start-qemu.sh` — QEMU launch for testing base VM
  - `documents/debug-arm64-netcoreapp.md` — Debug workflow for testing debug pack

  **Acceptance Criteria**:
  - [ ] Modular release design documented in `documents/release-structure.md`
  - [ ] Release script produces separate base + optional pack artifacts
  - [ ] Base VM boots independently and runs LLDB/GDB
  - [ ] Debug pack adds SOS capability when installed
  - [ ] Download docs updated with modular options
  - [ ] Chinese versions of new docs exist

  **QA Scenarios**:
  ```
  Scenario: Modular release artifact generation
    Tool: Bash
    Preconditions: Build output exists in BUILDROOT_DIR/output/images/
    Steps:
      1. Run: bash scripts/release-modular.sh arm64 (or equivalent)
      2. Assert: Exit code 0
      3. Run: ls *-arm64-base-*.tar.xz *-arm64-debug-pack-*.tar.xz
      4. Assert: Both base and debug pack archives exist
      5. Run: tar -tf *-arm64-base-*.tar.xz | head -20
      6. Assert: Archive contains rootfs, kernel, QEMU launch script
    Expected Result: Release script generates modular artifacts
    Failure Indicators: Script fails, missing artifacts, wrong archive contents
    Evidence: .sisyphus/evidence/task-10-modular-release.txt

  Scenario: Base VM boots independently
    Tool: Bash (interactive_bash for QEMU)
    Preconditions: Base VM archive extracted
    Steps:
      1. Run: scripts/arm64/start-qemu.sh (from extracted base)
      2. Wait for: "Welcome to Buildroot" or "buildroot login:"
      3. Assert: Login prompt appears
      4. Send: root (no password)
      5. Assert: Shell prompt (#) appears
    Expected Result: Base VM boots to login prompt without debug pack
    Failure Indicators: QEMU fails, kernel panic, no login prompt
    Evidence: .sisyphus/evidence/task-10-base-vm-boot.txt
  ```

  **Commit**: YES (groups with Wave 3)
  - Message: `feat(release): modular GitHub release with base VM + optional debug packs`
  - Files: `scripts/release-modular.sh`, `documents/release-structure.md`, `documents/download.md`, `documents/zh/`

- [x] 11. **GitHub Actions CI Pipeline**

  **What to do**:
  - Create `.github/workflows/ci.yml` for automated build verification:
    - Trigger: on push to main, on PR, weekly schedule (cron)
    - Job 1: Container image build verification (Docker/Podman)
    - Job 2: Buildroot defconfig + source download verification (arm64)
    - Job 3: Buildroot defconfig + source download verification (arm)
    - (Full build is too long for CI — verify configuration and downloads)
  - Use GitHub-hosted runners (ubuntu-latest)
  - Cache Buildroot dl/ directory using GitHub Actions cache
  - Add status badge to README.md
  - Document CI setup in `documents/ci.md` (bilingual)
  - Test: push a change and verify CI triggers and passes

  **Must NOT do**:
  - Do NOT attempt full Buildroot build in CI (takes hours, impractical on free runners)
  - Do NOT store secrets or credentials in workflow files
  - Do NOT configure deployment/release in CI yet — build verification only

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: GitHub Actions workflow creation + Docker integration + caching strategy
  - **Skills**: []
    - No specific skills needed — YAML workflow writing

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Task 12 — different concerns, but CI should exist before build tests run in CI)
  - **Parallel Group**: Wave 3 (with Tasks 10, 12, 13)
  - **Blocks**: Tasks 12 (build tests run in CI pipeline), 16 (container tests in CI)
  - **Blocked By**: Task 8 (container workflow), Task 10 (modular release structure)

  **References**:
  - `documents/tracking/next-steps.md` — Section 4: CI integration requirements
  - `tools/build-env/run.sh` — Container run script (CI will invoke)
  - `tools/build-env/Dockerfile` — Container definition (CI may rebuild)
  - `savedconfigs/arm64/br2.defconfig` — arm64 target configuration
  - `savedconfigs/arm/br2.defconfig` — arm target configuration
  - GitHub Actions docs: `https://docs.github.com/en/actions` — Workflow syntax, caching
  - `README.md` — For adding CI status badge

  **Acceptance Criteria**:
  - [ ] `.github/workflows/ci.yml` exists and is valid YAML
  - [ ] CI triggers on push to main branch
  - [ ] Container image builds successfully in CI
  - [ ] Defconfig verification passes for both arm64 and arm
  - [ ] README.md has CI status badge
  - [ ] `documents/ci.md` and `documents/zh/ci.md` exist

  **QA Scenarios**:
  ```
  Scenario: CI workflow syntax validation
    Tool: Bash
    Preconditions: .github/workflows/ci.yml exists
    Steps:
      1. Run: which yamllint || pip install yamllint (if available)
      2. Run: yamllint .github/workflows/ci.yml 2>&1 || python3 -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml'))"
      3. Assert: YAML parses without errors
      4. Run: gh workflow list (if gh CLI available and authenticated)
      5. Assert: ci.yml appears in workflow list
    Expected Result: CI workflow file is valid and registered with GitHub
    Failure Indicators: YAML syntax errors, workflow not detected by GitHub
    Evidence: .sisyphus/evidence/task-11-ci-validate.txt

  Scenario: CI badge in README
    Tool: Bash
    Preconditions: CI workflow created
    Steps:
      1. Run: grep "github.com/oldzhu/4dotnet/actions/workflows/ci.yml" README.md
      2. Assert: CI badge URL found (or similar badge syntax)
    Expected Result: README displays CI build status
    Evidence: .sisyphus/evidence/task-11-ci-badge.txt
  ```

  **Commit**: YES (groups with Wave 3)
  - Message: `ci(github): add CI pipeline for container build + defconfig verification`
  - Files: `.github/workflows/ci.yml`, `README.md`, `documents/ci.md`, `documents/zh/ci.md`

- [x] 12. **Build Verification Tests (arm64 + arm)**

  **What to do**:
  - Implement the placeholder test files created in Task 3:
  - `scripts/test/test-build-arm64.sh`:
    - Run `make defconfig` for arm64
    - Run `make` with timeout (monitor for download start + toolchain build)
    - Check exit codes and error output
    - Report: PASS if downloads start, FAIL if configuration errors
  - `scripts/test/test-build-arm.sh`:
    - Same as above for arm target
  - `scripts/test/test-container-build.sh` (placeholder, implemented in Task 16)
  - Update `scripts/test/common.sh` with:
    - `log_info()`, `log_pass()`, `log_fail()` functions
    - `assert_exit_code()`, `assert_output_contains()` functions
    - `setup_test()`, `teardown_test()` functions
  - Update `scripts/test/run-tests.sh` to run all test files
  - Integrate with CI (Task 11): add test execution step to workflow
  - All test output goes to `.sisyphus/evidence/` directory

  **Must NOT do**:
  - Do NOT run full Buildroot build (takes too long) — verify configuration + download start
  - Do NOT hardcode absolute paths (use $BUILDROOT_DIR, $FOURDOTNET_DIR variables)

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Shell script implementation following existing patterns
  - **Skills**: []
    - No specific skills needed

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Task 13 — different concerns)
  - **Parallel Group**: Wave 3 (with Tasks 10, 11, 13)
  - **Blocks**: Task 15 (VM tests build on this pattern)
  - **Blocked By**: Tasks 5, 6 (component upgrades), Task 11 (CI pipeline for integration)

  **References**:
  - `scripts/test/common.sh` — Test helper functions (from Task 3, now implementing)
  - `scripts/test/test-build-arm64.sh` — Placeholder (from Task 3, now implementing)
  - `scripts/test/test-build-arm.sh` — Placeholder (from Task 3, now implementing)
  - `savedconfigs/arm64/br2.defconfig` — Arm64 target config
  - `savedconfigs/arm/br2.defconfig` — Arm target config
  - `.github/workflows/ci.yml` — CI workflow (from Task 11, to integrate tests)

  **Acceptance Criteria**:
  - [ ] `scripts/test/test-build-arm64.sh` runs and produces PASS/FAIL result
  - [ ] `scripts/test/test-build-arm.sh` runs and produces PASS/FAIL result
  - [ ] `scripts/test/common.sh` has all helper functions documented
  - [ ] `scripts/test/run-tests.sh` orchestrates all tests
  - [ ] Tests integrated into CI workflow

  **QA Scenarios**:
  ```
  Scenario: Build verification test for arm64
    Tool: Bash
    Preconditions: Buildroot installed, 4dotnet at expected location
    Steps:
      1. Run: bash scripts/test/test-build-arm64.sh 2>&1
      2. Assert: Exit code 0 on success (or expect 1 if infrastructure missing — documented)
      3. Assert: Output contains "PASS" or clearly states what failed
      4. Run: ls .sisyphus/evidence/
      5. Assert: Evidence file exists for test run
    Expected Result: Build verification test runs and reports clear result
    Failure Indicators: Script crashes without output, no evidence file
    Evidence: .sisyphus/evidence/task-12-build-test.txt
  ```

  **Commit**: YES (groups with Wave 3)
  - Message: `test(build): implement build verification tests for arm64 and arm targets`
  - Files: `scripts/test/`

- [x] 13. **Chinese Documentation Batch 2 (Debug Docs)**

  **What to do**:
  - Translate debug documentation to Chinese:
    - `documents/debug-arm64-netcoreapp.md` → `documents/zh/debug-arm64-netcoreapp.md`
    - `documents/debug-arm-netcoreapp.md` → `documents/zh/debug-arm-netcoreapp.md`
    - `documents/debug-linux-kernel.md` → `documents/zh/debug-linux-kernel.md`
    - `documents/debug-lldb-sos.md` → `documents/zh/debug-lldb-sos.md`
    - `documents/debug-qemu.md` → `documents/zh/debug-qemu.md`
  - Cross-link Chinese ↔ English versions
  - Preserve all code blocks, LLDB commands, GDB commands exactly
  - Translate explanatory text and procedure descriptions

  **Must NOT do**:
  - Do NOT translate LLDB/GDB command output (e.g., register dumps, stack traces)
  - Do NOT modify English originals

  **Recommended Agent Profile**:
  - **Category**: `writing`
    - Reason: Translation work with bilingual fluency
  - **Skills**: []
    - No specific skills needed

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Task 12 — completely independent)
  - **Parallel Group**: Wave 3 (with Tasks 10, 11, 12)
  - **Blocks**: None directly
  - **Blocked By**: Task 4 (template), Task 9 (batch 1 for consistency)

  **References**:
  - `documents/zh/TEMPLATE.md` — Documentation template
  - `documents/zh/` — Existing Chinese docs for style consistency
  - `documents/debug-arm64-netcoreapp.md` — Source for translation
  - `documents/debug-arm-netcoreapp.md` — Source for translation
  - `documents/debug-linux-kernel.md` — Source for translation
  - `documents/debug-lldb-sos.md` — Source for translation
  - `documents/debug-qemu.md` — Source for translation

  **Acceptance Criteria**:
  - [ ] 5 Chinese debug doc files created
  - [ ] Each contains complete, accurate translation
  - [ ] Debug commands and output preserved verbatim
  - [ ] Cross-reference links working

  **QA Scenarios**:
  ```
  Scenario: Debug docs translation verification
    Tool: Bash
    Preconditions: Task 9 completed
    Steps:
      1. Run: ls documents/zh/debug-*.md
      2. Assert: 5 debug doc files exist
      3. Run: grep -l "lldb\|LLDB" documents/zh/debug-arm64-netcoreapp.md
      4. Assert: Technical terms preserved
      5. Run: wc -l documents/zh/debug-arm64-netcoreapp.md documents/debug-arm64-netcoreapp.md
      6. Assert: Line counts roughly comparable
    Expected Result: All debug docs translated with technical accuracy
    Failure Indicators: Missing files, lost technical terms, significant content mismatch
    Evidence: .sisyphus/evidence/task-13-zh-batch2.txt
  ```

  **Commit**: YES (groups with Wave 3)
  - Message: `docs(zh): translate all debug documentation to Chinese`
  - Files: `documents/zh/debug-*.md`

---

- [x] 14. **Release Process Simplification (One-Click Script)**

  **What to do**:
  - Create `scripts/release.sh` — unified one-click release script
  - Script should:
    - Accept architecture parameter: `arm64` or `arm`
    - Accept optional flags: `--full` (single archive), `--modular` (default), `--dry-run`
    - Orchestrate: build verification → artifact generation → checksum creation → GitHub release upload (via gh CLI)
    - Generate release notes automatically from git log
    - Validate all artifacts before upload
  - Integrate with modular release from Task 10
  - Update `documents/publish.md` with simplified release instructions
  - Update `documents/zh/publish.md` with Chinese version
  - Test: run `scripts/release.sh --dry-run arm64` and verify output

  **Must NOT do**:
  - Do NOT automatically push to GitHub Releases without confirmation
  - Do NOT replace existing release scripts — add new script alongside them
  - Do NOT remove the manual release workflow as fallback

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Shell script creation following existing patterns
  - **Skills**: []
    - No specific skills needed

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 15, 16, 17 — independent work)
  - **Parallel Group**: Wave 4 (with Tasks 15, 16, 17)
  - **Blocks**: None (final task)
  - **Blocked By**: Task 10 (modular release structure)

  **References**:
  - `scripts/releasefull.sh` — Existing release script (reference for workflow)
  - `scripts/releaseit.sh` — Existing release helper
  - `scripts/release-modular.sh` — New modular release script (from Task 10)
  - `scripts/pub2img.sh` — Image publishing script (reference)
  - `documents/publish.md` — Current publish docs (to update)
  - GitHub CLI docs: `gh release create` — For GitHub release automation

  **Acceptance Criteria**:
  - [ ] `scripts/release.sh` exists and is executable
  - [ ] `--dry-run` mode works without side effects
  - [ ] `--help` shows usage information
  - [ ] Script validates required dependencies (gh CLI, build artifacts)
  - [ ] Release docs updated with simplified instructions

  **QA Scenarios**:
  ```
  Scenario: Release script dry-run
    Tool: Bash
    Preconditions: Build artifacts may or may not exist
    Steps:
      1. Run: bash scripts/release.sh --dry-run arm64 2>&1
      2. Assert: Script runs without crash, shows what it WOULD do
      3. Assert: Output mentions "dry-run" or "would" (indicating no actual release)
      4. Run: bash scripts/release.sh --help 2>&1
      5. Assert: Usage information displayed
    Expected Result: Release script accepts parameters and performs dry-run
    Failure Indicators: Script crashes, --help fails, --dry-run does actual changes
    Evidence: .sisyphus/evidence/task-14-release-dryrun.txt

  Scenario: Release script validation checks
    Tool: Bash
    Preconditions: gh CLI may not be installed/authenticated
    Steps:
      1. Run: bash scripts/release.sh --dry-run arm64 2>&1
      2. Assert: If gh CLI missing, script reports "gh not found" clearly
      3. Assert: If artifacts missing, script reports "artifacts not found" clearly
    Expected Result: Script gracefully handles missing dependencies
    Evidence: .sisyphus/evidence/task-14-validation.txt
  ```

  **Commit**: YES (groups with Wave 4)
  - Message: `feat(release): add one-click release script with dry-run support`
  - Files: `scripts/release.sh`, `documents/publish.md`, `documents/zh/publish.md`

- [x] 15. **VM Boot + Debugging Smoke Tests**

  **What to do**:
  - Implement VM boot verification tests:
    - `scripts/test/test-vm-boot-arm64.sh`:
      - Start QEMU with arm64 VM image
      - Wait for login prompt (timeout: 120s)
      - Send login as root
      - Verify shell prompt appears
      - Run `uname -a` to verify Linux kernel
      - Clean shutdown
    - `scripts/test/test-vm-boot-arm.sh`:
      - Same for arm target
  - Implement debugging smoke test:
    - After VM boot, run `lldb dotnethello/dotnethello`
    - Verify LLDB starts and loads the executable
    - Verify SOS plugin is detected (check for "Using .NET Core runtime to host the managed SOS code")
    - Run `r` (run) in LLDB
    - Verify "Hello World from .NET" appears in output
    - Clean exit
  - Update `scripts/test/run-tests.sh` to include VM tests
  - Document VM test prerequisites (QEMU, VM images, memory requirements)
  - Mark VM tests as optional in CI (may exceed CI resource limits)

  **Must NOT do**:
  - Do NOT run VM tests in GitHub Actions CI (resource constraints) — mark as manual/local only
  - Do NOT hardcode VM image paths (use configurable variables)

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Complex test scripting with QEMU automation, LLDB interaction, and timeout handling
  - **Skills**: []
    - No specific skills needed — bash scripting with QEMU/LDB

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 14, 16, 17)
  - **Parallel Group**: Wave 4 (with Tasks 14, 16, 17)
  - **Blocks**: None (final task)
  - **Blocked By**: Tasks 5, 6 (component upgrades), Task 12 (build tests pattern), Task 14 (release script)

  **References**:
  - `scripts/arm64/start-qemu.sh` — QEMU launch command for arm64
  - `scripts/arm/start-qemu.sh` — QEMU launch command for arm
  - `documents/debug-arm64-netcoreapp.md` — Expected LLDB output
  - `documents/debug-arm-netcoreapp.md` — ARM-specific behavior (illegal instruction workaround)
  - `scripts/test/common.sh` — Test helper functions
  - `scripts/test/test-vm-boot-arm64.sh` — Placeholder from Task 3 (now implementing)

  **Acceptance Criteria**:
  - [ ] VM boot test for arm64 passes when VM image is available
  - [ ] VM boot test gracefully skips when VM image not found
  - [ ] Debugging smoke test verifies LLDB + dotnethello + SOS
  - [ ] Tests produce clear PASS/FAIL/SKIP output

  **QA Scenarios**:
  ```
  Scenario: VM boot test (with VM image available)
    Tool: Bash (interactive_bash for QEMU/tmux)
    Preconditions: arm64 VM image built (rootfs.ext4, Image kernel)
    Steps:
      1. Run: bash scripts/test/test-vm-boot-arm64.sh 2>&1
      2. Assert: QEMU starts (no immediate crash)
      3. Assert: Output shows "Welcome to Buildroot" within 120s
      4. Assert: "uname -a" output contains "aarch64" or "Linux"
    Expected Result: VM boots successfully and runs commands
    Failure Indicators: QEMU crash, timeout without login prompt, kernel panic
    Evidence: .sisyphus/evidence/task-15-vm-boot.txt

  Scenario: Debugging smoke test
    Tool: Bash (interactive_bash for tmux with LLDB)
    Preconditions: VM booted, dotnethello installed
    Steps:
      1. Send: lldb dotnethello/dotnethello
      2. Assert: LLDB prompt "(lldb)" appears
      3. Send: r
      4. Assert: Output contains "Hello World from .NET"
      5. Assert: SOS message appears ("Using .NET Core runtime...")
    Expected Result: LLDB debugging with SOS works on upgraded components
    Failure Indicators: LLDB not found, dotnethello not found, SIGILL on ARM
    Evidence: .sisyphus/evidence/task-15-debug-smoke.txt
  ```

  **Commit**: YES (groups with Wave 4)
  - Message: `test(vm): add VM boot and debugging smoke tests`
  - Files: `scripts/test/test-vm-boot-*.sh`, `scripts/test/run-tests.sh`

- [x] 16. **Container Build Verification Tests**

  **What to do**:
  - Implement container build test:
    - `scripts/test/test-container-build.sh`:
      - Check Docker/Podman availability
      - Build container image (if not already built)
      - Run `make defconfig` inside container
      - Start `make` and verify downloads begin
      - Verify dl/ cache persistence (touch test from Task 8)
      - Verify ccache is configured
      - Report PASS/FAIL for each check
  - Update `scripts/test/run-tests.sh` to include container tests
  - Integrate with CI (Task 11): add container test to CI workflow
  - Document container test in `scripts/test/README.md`

  **Must NOT do**:
  - Do NOT attempt full Buildroot build in container (time/resource constraints)
  - Do NOT run container tests if Docker/Podman not available (graceful skip)

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Shell script testing following established patterns
  - **Skills**: []
    - No specific skills needed

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 14, 15, 17)
  - **Parallel Group**: Wave 4 (with Tasks 14, 15, 17)
  - **Blocks**: None (final task)
  - **Blocked By**: Task 8 (container workflow), Task 11 (CI integration)

  **References**:
  - `tools/build-env/run.sh` — Container run script (what to test)
  - `tools/build-env/Dockerfile` — Container definition (what gets tested)
  - `documents/build-container.md` — Container docs (expected behavior)
  - `scripts/test/common.sh` — Test helper functions
  - `scripts/test/test-container-build.sh` — Placeholder from Task 3 (now implementing)
  - `.github/workflows/ci.yml` — CI workflow (to integrate)

  **Acceptance Criteria**:
  - [ ] Container test verifies image build or skips gracefully if no Docker
  - [ ] Container test verifies defconfig works inside container
  - [ ] Container test verifies dl/ cache persistence
  - [ ] Container test verifies ccache configuration
  - [ ] Test integrated into CI workflow

  **QA Scenarios**:
  ```
  Scenario: Container build test execution
    Tool: Bash
    Preconditions: Docker/Podman available
    Steps:
      1. Run: bash scripts/test/test-container-build.sh 2>&1
      2. Assert: Script reports Docker/Podman detection
      3. Assert: Script reports image build status (pass/fail/skip)
      4. Assert: Script reports defconfig status (pass/fail)
      5. Assert: Script reports cache status (pass/fail)
    Expected Result: Container test validates each aspect of the container workflow
    Failure Indicators: Docker detection fails incorrectly, cache test unreliable
    Evidence: .sisyphus/evidence/task-16-container-test.txt
  ```

  **Commit**: YES (groups with Wave 4)
  - Message: `test(container): add container build verification tests`
  - Files: `scripts/test/test-container-build.sh`, `scripts/test/run-tests.sh`, `scripts/test/README.md`

- [x] 17. **Chinese Documentation Batch 3 (Remaining + README Update)**

  **What to do**:
  - Translate remaining documentation to Chinese:
    - `documents/workaround4illegalinstruction.md` → `documents/zh/workaround4illegalinstruction.md`
    - `documents/pocpatch4illegalinstruction.md` → `documents/zh/pocpatch4illegalinstruction.md`
    - `documents/release-structure.md` → `documents/zh/release-structure.md` (from Task 10)
    - `documents/ci.md` → `documents/zh/ci.md` (from Task 11)
    - `documents/tracking/next-steps.md` → `documents/zh/tracking/next-steps.md`
  - Update root `README.md` to add comprehensive Chinese documentation index
  - Add Chinese language selector note at top of README
  - Verify all Chinese-English cross-links work
  - Update `documents/zh/README.md` with links to all translated docs
  - Final review: ensure all English docs have Chinese counterparts

  **Must NOT do**:
  - Do NOT translate workaround/patch code — preserve commands exactly
  - Do NOT remove any English content from README

  **Recommended Agent Profile**:
  - **Category**: `writing`
    - Reason: Final batch of translations + integration work
  - **Skills**: []
    - No specific skills needed

  **Parallelization**:
  - **Can Run In Parallel**: YES (with Tasks 14, 15, 16)
  - **Parallel Group**: Wave 4 (with Tasks 14, 15, 16)
  - **Blocks**: None (final documentation task)
  - **Blocked By**: Task 4 (template), Tasks 10, 11 (new docs to translate)

  **References**:
  - `documents/workaround4illegalinstruction.md` — Source for translation
  - `documents/pocpatch4illegalinstruction.md` — Source for translation
  - `documents/release-structure.md` — From Task 10 (new doc to translate)
  - `documents/ci.md` — From Task 11 (new doc to translate)
  - `documents/tracking/next-steps.md` — Source for translation
  - `README.md` — To update with Chinese index
  - `documents/zh/` — All existing Chinese docs

  **Acceptance Criteria**:
  - [ ] All remaining English docs have Chinese translations
  - [ ] Root README has Chinese documentation index
  - [ ] All Chinese docs cross-link back to English originals
  - [ ] `documents/zh/README.md` updated with full doc index

  **QA Scenarios**:
  ```
  Scenario: Complete Chinese documentation coverage
    Tool: Bash
    Preconditions: All previous tasks completed
    Steps:
      1. Run: ls documents/*.md | while read f; do base=$(basename "$f"); [ -f "documents/zh/$base" ] || echo "MISSING: $base"; done
      2. Assert: No output (all English docs have Chinese counterparts)
      3. Run: grep "中文" README.md
      4. Assert: Chinese language link/section exists
      5. Run: cat documents/zh/README.md | wc -l
      6. Assert: Content is substantial (>= 20 lines)
    Expected Result: Complete Chinese documentation coverage
    Failure Indicators: Missing translation for any English doc, broken links
    Evidence: .sisyphus/evidence/task-17-zh-batch3.txt
  ```

  **Commit**: YES (groups with Wave 4)
  - Message: `docs(zh): complete Chinese documentation coverage with index`
  - Files: `documents/zh/`, `README.md`

---

## Final Verification Wave

**MANDATORY — after ALL implementation tasks complete.**

> 4 review agents run in PARALLEL. ALL must APPROVE. Present consolidated results to user and get explicit "okay" before completing.
> Do NOT auto-proceed after verification. Wait for user's explicit approval before marking work complete.

- [x] F1. **Plan Compliance Audit** — APPROVE (5/5 Must Have, 5/5 Must NOT Have)
  Read the plan end-to-end. For each "Must Have": verify implementation exists (read file, run command). For each "Must NOT Have": search codebase for forbidden patterns — reject with file:line if found. Check evidence files exist in .sisyphus/evidence/. Compare deliverables against plan.
  Output: `Must Have [N/N] | Must NOT Have [N/N] | Tasks [17/17] | Evidence [N/17] | VERDICT: APPROVE/REJECT`

- [x] F2. **Code Quality Review** — APPROVE (shell scripts valid, CI YAML valid, 1 pre-existing issue)
  Run shellcheck on all modified .sh files. Check for: hardcoded paths, unquoted variables, missing error handling, unsafe commands (rm -rf without checks). Check Buildroot .mk syntax validity. Verify CI YAML is valid. Check for AI slop: excessive comments, over-abstraction, unused variables.
  Output: `Scripts [N clean/N issues] | Buildroot [PASS/FAIL] | CI YAML [PASS/FAIL] | VERDICT`

- [x] F3. **Real Manual QA** — APPROVE (10/10 pass, 2 gracefully skipped)
  Start from clean state. Execute EVERY QA scenario from EVERY task — follow exact steps, capture evidence. Test cross-task integration: container build → modular release → VM boot → debugging. Test edge cases: missing Docker, missing artifacts, clean checkout. Save to `.sisyphus/evidence/final-qa/`.
  Output: `Scenarios [N/N pass] | Integration [N/N] | Edge Cases [N tested] | VERDICT`

- [x] F4. **Scope Fidelity Check** — APPROVE (17/17 compliant, no contamination)
  For each task: read "What to do", read actual diff (git log/diff). Verify 1:1 — everything in spec was built (no missing), nothing beyond spec was built (no creep). Check "Must NOT do" compliance. Detect cross-task contamination: Task N touching Task M's files. Flag unaccounted changes.
  Output: `Tasks [17/17 compliant] | Contamination [CLEAN/N issues] | Unaccounted [CLEAN/N files] | VERDICT`

---

## Commit Strategy

| Wave | Commit Message | Files |
|------|---------------|-------|
| 1 | `chore: BMAD setup, chat infra, test scaffold, Chinese docs template` | `.bmad-output/`, `documents/chat/`, `scripts/test/`, `documents/zh/`, `README.md` |
| 2 | `feat: upgrade LLDB + dotnetruntime to main, container caches, smoke test` | `package/lldb/`, `package/dotnetcore/dotnetruntime/`, `tools/build-env/run.sh`, `documents/` |
| 3 | `feat: modular release, CI pipeline, build tests, Chinese debug docs` | `scripts/release-modular.sh`, `.github/workflows/`, `scripts/test/`, `documents/` |
| 4 | `feat: release script, VM tests, container tests, complete Chinese docs` | `scripts/release.sh`, `scripts/test/`, `documents/zh/`, `README.md` |

---

## Success Criteria

### Verification Commands
```bash
# All tests pass
bash scripts/test/run-tests.sh

# CI status (after push)
gh run list --workflow=ci.yml --limit=1

# BMAD context valid
cat .bmad-output/project-context.md | grep -c "Buildroot"

# Chinese docs complete
ls documents/zh/*.md | wc -l  # Should be >= 15
```

### Final Checklist
- [x] All 17 implementation tasks completed
- [ ] Container build succeeds for arm64 and arm (defconfig verified; full `make` needs ~hours)
- [ ] LLDB package builds from main branch (Config.in updated; full build needs ~hours)
- [ ] .NET runtime package builds from main branch (Config.in updated; full build needs ~hours)
- [x] Modular release artifacts generate correctly (script tested with --dry-run)
- [ ] CI pipeline passes on push (YAML valid; needs push to trigger)
- [x] All English docs have Chinese counterparts (>= 15 files)
- [x] Chat infrastructure functional
- [x] BMAD project context accurate
- [x] All evidence files present in .sisyphus/evidence/
- [x] 4 review agents (F1-F4) all return APPROVE
- [ ] User explicitly confirms work is complete
