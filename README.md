# 4dotnet
The repository is building a Linux arm/arm64 VM for debugging a .NET core application from bottom to top.  

The arm/arm64 VM has:

1. The latest linux system (5.10.x build by the buildroot gcc toolchain)
2. The latest gdb (10.x build by the buildroot gcc toolchain)
3. The latest lldb (master branch build by the buildroot gcc toolchain)
4. The latest SOS lldb plugin (master branch build by msbuild with the host clang/llvm(for native part) + MS compilers(for managed part)) 
5. A selfcontained .NET core applciation with the latest .NET core runtime (master branch build by msbuild with the host clang/llvm(for native part) and MS compilers(for managed part))

The host (x86) version clang/llvm is built from master branch by the buildroot gcc toolchain, then it is used to cross compile the above SOS lldb plugin and the native part of the .NET core runtime for arm/arm64 target. 

[Build arm/arm64 VM (Linux + QEMU + GDB + LLDB + SOS + .NET Core runtime) for .NET core application debugging](build.md)  
[Using the arm/arm64 VM built to debug](debug.md)