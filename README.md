# 4dotnet
The repository is building a Linux arm/arm64 VM for a .NET core application debugging in WSL2.  

The target arm/arm64 VM contains:

- The linux system (5.11.x) - build by the buildroot gcc toolchain
- The gdb (10.x) - build by the buildroot gcc toolchain
- The lldb (main branch) - build by the buildroot gcc toolchain
- The SOS lldb plugin (main branch) - build by the clang/llvm(for native part) + MS compilers(for managed part)
- A selfcontained .NET core applciation with the .NET core runtime (main branch) - build by the host clang/llvm(for native part) and MS compilers(for managed part))

Also have the following tools built for the host x86-64:

* The qemu (5.2.0) - build by the buildroot gcc toochain, which is used to host the arm/arm64 vm built.  
* The latest clang/llvm (main branch) - build by buildroot gcc toolchain, which is used to cross compile the above SOS lldb plugin and the native part of the .NET core runtime for arm/arm64 target.  
 
1. [Build arm/arm64 VM (Linux + GDB + LLDB + SOS + .NET Core applcation)](build.md)  
2. [Using the amr64 VM  to debug](debug-arm64.md)
3. [Using the arm VM to debug](debug-arm.md)
4. [Publish yourself .net core app to vm for debugging](pulish.md)