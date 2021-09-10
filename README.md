# 4dotnet
The repository is building a Linux arm/arm64 VM in WSL2 so you can play with .NET core debugging on arm/arm64 system as the below without buying a real hardware. 

Two goals of the project:  
1. Lower the gate to play .net core app on Linux arm/arm64.
2. Provide a "All-In-One" package and a "Full Stack" debugging experience in OSS world(from qemu,linux kernel,clang/llvm,lldb/gdb,sos,.net core app)

<img src="documents/armdemo.gif" alt=".net core debugging demo on arm vm" width="1500"/>

The target arm/arm64 VM contains:

- The linux system (5.13.9) - build by the buildroot gcc toolchain
- The gdb (10.x) - build by the buildroot gcc toolchain
- The lldb (13.0.x) - build by the buildroot gcc toolchain
- The SOS lldb plugin (main branch) - build by the clang/llvm(for native part) + MS compilers(for managed part)
- A selfcontained .NET core applciation with the .NET core runtime (.net core 6.0 RC) - build by the host clang/llvm(for native part) and MS compilers(for managed part))

Also have the following tools built for the host x86-64:

* The qemu (6.0.0) - build by the buildroot gcc toochain, which is used to host the arm/arm64 vm built.  
* The latest clang/llvm (main branch) - build by buildroot gcc toolchain, which is used to cross compile the above SOS lldb plugin and the native part of the .NET core runtime for arm/arm64 target.  
  
There are two ways to get the VM package to play:

1. [build arm/arm64 VM (Linux + GDB + LLDB + SOS + .NET Core applcation) from scratch](documents/build.md)  
  Building from scratch could take several hours or even longer, it depends on how powerful of the hardware is.  
  or  
2. [You can donwload the released VM and use it directly](documents/download.md)

After build or download the VM package, you can  

1. [.net core app on arm64 vm debugging](documents/debug-arm64-netcoreapp.md)
2. [.net core app on arm vm debugging](documents/debug-arm-netcoreapp.md)
3. [publish a .net core app to vm for debugging](documents/publish.md)
4. [host qemu debugging](documents/debug-qemu.md)
5. [linux lernel debugging](documents/debug-linux-kernel.md)
6. [lldb sos plugin debugging](documents/debug-lldb-sos.md)