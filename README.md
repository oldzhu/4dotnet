# 4dotnet
The repository is building a Linux arm/arm64 VM for debugging a .NET core application from bottom to top.  

The target arm/arm64 VM has:

- The latest linux system (5.10.x) - build by the buildroot gcc toolchain)
- The latest gdb (10.x) - build by the buildroot gcc toolchain)
- The latest lldb (master branch) - build by the buildroot gcc toolchain)
- The latest SOS lldb plugin (master branch) - build by msbuild with the host clang/llvm(for native part) + MS compilers(for managed part)) 
- A selfcontained .NET core applciation with the latest .NET core runtime (master branch) - build by msbuild with the host clang/llvm(for native part) and MS compilers(for managed part))

We also have the following built for host x86:

* The latest qemu (5.2.0) - build by the buildroot gcc toochain, which is used to host the arm/arm64 vm built.  
* The latest clang/llvm (master branch) - build by buildroot gcc toolchain, which is used to cross compile the above SOS lldb plugin and the native part of the .NET core runtime for arm/arm64 target.  
 
1. [Build arm/arm64 VM (Linux + GDB + LLDB + SOS + .NET Core applcation)](build.md)  
2. [Using the amr64 VM built to debug](debug-arm64.md)
3. [Using the arm VM built to debug](debug-arm.md)