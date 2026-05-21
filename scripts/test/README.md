# Test Framework / 测试框架

## Overview / 概述
4dotnet test framework for build verification, VM boot testing, and debugging smoke tests.

## Structure / 结构
```
scripts/test/
├── README.md              # This file
├── common.sh              # Shared helper functions
├── run-tests.sh           # Test orchestrator
├── test-build-arm64.sh    # ARM64 build verification
├── test-build-arm.sh      # ARM build verification
├── test-vm-boot-arm64.sh  # ARM64 VM boot test
├── test-vm-boot-arm.sh    # ARM VM boot test
└── test-container-build.sh # Container build test
```

## Usage / 使用方法
```bash
bash scripts/test/run-tests.sh     # Run all tests
bash scripts/test/test-build-arm64.sh  # Run specific test
```

## Helper Functions / 辅助函数
| Function | Description |
|----------|-------------|
| `log_info(msg)` | Print informational message |
| `log_pass(msg)` | Print pass + increment counter |
| `log_fail(msg)` | Print fail + increment counter |
| `log_skip(msg, reason)` | Print skip + increment counter |
| `assert_eq(name, expected, actual)` | Assert two values equal |
| `assert_contains(name, needle, haystack)` | Assert string contains substring |
| `assert_file_exists(name, path)` | Assert file exists |
| `assert_dir_exists(name, path)` | Assert directory exists |
| `assert_exit_code(name, expected, cmd)` | Assert command exit code |
| `setup_test(name)` | Initialize test |
| `teardown_test` | Print summary |
| `save_evidence(name, content)` | Save evidence file |

## Evidence / 证据
Test evidence saved to `.sisyphus/evidence/` directory.
