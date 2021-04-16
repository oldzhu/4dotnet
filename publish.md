How to publish a .netcore app to the arm/arm64 vm.  

if you build the arm/arm64 vm using the steps [Build arm/arm64 VM (Linux + GDB + LLDB + SOS + .NET Core applcation)](build.md) from scratch,  
you can use vi or vscode to modify the dotnethello source which is ~/4dotnet/package/dotnethello/src/Program.cs to add your customize code,  
then run the below command to rebuild the dotnethello and the new system image for debugging.  
~~~
        make dotnethello-rebuild all
~~~  

If you download and use the release arm/arm64 vm directly, refer the below steps to publish a .netcore app with the released .net core runtime to the VM image to debug:  
The steps is similiar as  [Deploy self-contained .NET apps to Raspberry Pi](https://docs.microsoft.com/en-us/dotnet/iot/deployment#deploying-a-self-contained-app).
1. Install .NET core in WSL2 if you.
~~~
curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin
~~~
***If you need a specific version, add --version <VERSION> to the end, where <VERSION> is the specific build version.***
~~~
echo 'export DOTNET_ROOT=$HOME/.dotnet' >> ~/.bashrc
echo 'export PATH=$PATH:$HOME/.dotnet' >> ~/.bashrc
source ~/.bashrc
dotnet --info
~~~
2. Run the below command to create a new console program
~~
dotnet new console -n myhello
~~
3. Use vi or VScode to modify the Program.cs under the myhello directory as the below so that it wait for your input before exit.
~~~
using System;

namespace myhello
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
            Console.ReadLine();
        }
    }
}
~~~
4. Run the below command in the myhello folder to pulish self-contained app for linux arm or arm64
for linux arm
~~~
cd myhello
dotnet publish -r linux-arm -c Release
~~~ 
for linux-arm64
~~~
cd myhello
dotnet publish -r linux-arm64 -c Release
~~~
5. Run the pub2img.sh which is lcoated in the same folder as the arm/arm64 VM to publish the self-contained app to the arm/arm64 VM image. 
~~~
[usage]pub2img.sh [local publish path] [target folder name]
~~~
for arm example
~~~
~/vm_releases/04-04-2021/arm/pub2img.sh /home/oldzhu/myhello/bin/Release/netcoreapp3.1/linux-arm/publish/ myhello
~~~
for arm64 example
~~~
~/vm_releases/04-04-2021/arm64/pub2img.sh /home/oldzhu/myhello/bin/Release/netcoreapp3.1/linux-arm64/publish/ myhello
~~~
***04-04-2021 could be different for the different VM release ***
6. Start the VM for debugging.
for arm example
~~~
~/vm_releases/04-04-2021/arm/start-qemu.sh
~~~
for arm 64 example
~~~
~/vm_releases/04-04-2021/arm64/start-qemu.sh
~~~
7. Login as root and enjoy the debugging.
for arm example
~~~
~~~
for arm64 example:
~~~
Welcome to Buildroot
buildroot login: root
# lldb myhello/myhello
(lldb) target create "myhello/myhello"
Current executable set to '/root/myhello/myhello' (aarch64).
(lldb) r
Process 128 launched: '/root/myhello/myhello' (aarch64)
Process 128 stopped and restarted: thread 1 received signal: SIGCHLD
Process 128 stopped and restarted: thread 1 received signal: SIGCHLD
Hello World!
Process 128 stopped
* thread #1, name = 'myhello', stop reason = signal SIGSTOP
    frame #0: 0x0000007ff7fac330 libpthread.so.0`__libc_read at read.c:26:10
   23   ssize_t
   24   __libc_read (int fd, void *buf, size_t nbytes)
   25   {
-> 26     return SYSCALL_CANCEL (read, fd, buf, nbytes);
                 ^
   27   }
   28   libc_hidden_def (__libc_read)
   29
libpthread.so.0`__libc_read:
->  0x7ff7fac330 <+112>: svc    #0
    0x7ff7fac334 <+116>: mov    x19, x0
    0x7ff7fac338 <+120>: cmn    x0, #0x1, lsl #12         ; =0x1000
    0x7ff7fac33c <+124>: b.hi   0x7ff7fac374              ; <+180> [inlined] __libc_read at read.c:26:10
(lldb) sethostruntime /root/myhello
Using .NET Core runtime to host the managed SOS code
Host runtime path: /root/myhello
(lldb) setsymbolserver -ms
Added Microsoft public symbol server
(lldb) loadsymbols
(lldb) bt
* thread #1, name = 'myhello', stop reason = signal SIGSTOP
  * frame #0: 0x0000007ff7fac330 libpthread.so.0`__libc_read at read.c:26:10
    frame #1: 0x0000007ff7fac318 libpthread.so.0`__libc_read(fd=<unavailable>, buf=0x0000007fffffe3b0, nbytes=1024) at read.c:24
    frame #2: 0x0000007ff20fa320 System.Native.so`SystemNative_ReadStdin(buffer=<unavailable>, bufferSize=<unavailable>) at pal_console.c:393:37
    frame #3: 0x0000007f7e41054c
    frame #4: 0x0000007f7e53b870
    frame #5: 0x0000007f7e53a7fc
    frame #6: 0x0000007f7e53a734
    frame #7: 0x0000007f7e5396f0
    frame #8: 0x0000007f7e52aa6c
    frame #9: 0x0000007f7e3f99e4
    frame #10: 0x0000007ff7565814 libcoreclr.so`CallDescrWorkerInternal at calldescrworkerarm64.S:72
    frame #11: 0x0000007ff749effc libcoreclr.so`MethodDescCallSite::CallTargetWorker(unsigned long const*, unsigned long*, int) at callhelpers.cpp:70:5
    frame #12: 0x0000007ff749ef9c libcoreclr.so`MethodDescCallSite::CallTargetWorker(this=<unavailable>, pArguments=0x0000007fffffedd0, pReturnValue=0x0000000000000000, cbReturnValue=0) at callhelpers.cpp:604
    frame #13: 0x0000007ff757971c libcoreclr.so`RunMain(MethodDesc*, short, int*, PtrArray**) [inlined] MethodDescCallSite::Call(this=0x0000007f7e48ff48, pArguments=0x0000007f60003920) at callhelpers.h:468:9
    frame #14: 0x0000007ff7579708 libcoreclr.so`RunMain(MethodDesc*, short, int*, PtrArray**) at assembly.cpp:1556
    frame #15: 0x0000007ff75795cc libcoreclr.so`RunMain(MethodDesc*, short, int*, PtrArray**) at assembly.cpp:1571
    frame #16: 0x0000007ff7579590 libcoreclr.so`RunMain(pFD=<unavailable>, numSkipArgs=<unavailable>, piRetVal=<unavailable>, stringArgs=<unavailable>) at assembly.cpp:1571
    frame #17: 0x0000007ff7579a60 libcoreclr.so`Assembly::ExecuteMainMethod(this=<unavailable>, stringArgs=0x0000007ffffff2d8, waitForOtherThreads=YES) at assembly.cpp:1681:18
    frame #18: 0x0000007ff73e91c4 libcoreclr.so`CorHost2::ExecuteAssembly(this=<unavailable>, dwAppDomainId=<unavailable>, pwzAssemblyPath=<unavailable>, argc=<unavailable>, argv=0x0000000000000000, pReturnValue=0x0000007ffffff428) at corhost.cpp:460:39
    frame #19: 0x0000007ff73c0330 libcoreclr.so`::coreclr_execute_assembly(hostHandle=0x000000000049d560, domainId=1, argc=0, argv=<unavailable>, managedAssemblyPath=<unavailable>, exitCode=0x0000007ffffff428) at unixinterface.cpp:412:24
    frame #20: 0x0000007ff7b0221c libhostpolicy.so`run_app_for_context(context=<unavailable>, argc=<unavailable>, argv=<unavailable>) at hostpolicy.cpp:241:32
    frame #21: 0x0000007ff7b0256c libhostpolicy.so`run_app(argc=0, argv=0x0000007ffffffd70) at hostpolicy.cpp:276:12
    frame #22: 0x0000007ff7b02d78 libhostpolicy.so`::corehost_main(argc=1, argv=<unavailable>) at hostpolicy.cpp:390:12
    frame #23: 0x0000007ff7b771c8 libhostfxr.so`fx_muxer_t::handle_exec_host_command(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, host_startup_info_t const&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::unordered_map<known_options, std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >, known_options_hash, std::equal_to<known_options>, std::allocator<std::pair<known_options const, std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > > > > const&, int, char const**, int, host_mode_t, char*, int, int*) at fx_muxer.cpp:146:20
    frame #24: 0x0000007ff7b77108 libhostfxr.so`fx_muxer_t::handle_exec_host_command(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, host_startup_info_t const&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::unordered_map<known_options, std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >, known_options_hash, std::equal_to<known_options>, std::allocator<std::pair<known_options const, std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > > > > const&, int, char const**, int, host_mode_t, char*, int, int*) [inlined] (anonymous namespace)::read_config_and_execute(host_command=<unavailable>, host_info=<unavailable>, app_candidate=<unavailable>, opts=<unavailable>, new_argc=<unavailable>, new_argv=<unavailable>, mode=<unavailable>) at fx_muxer.cpp:502
    frame #25: 0x0000007ff7b770e4 libhostfxr.so`fx_muxer_t::handle_exec_host_command(host_command=<unavailable>, host_info=<unavailable>, app_candidate=<unavailable>, opts=<unavailable>, argc=<unavailable>, argv=<unavailable>, argoff=<unavailable>, mode=<unavailable>, result_buffer=<unavailable>, buffer_size=<unavailable>, required_buffer_size=<unavailable>) at fx_muxer.cpp:952
    frame #26: 0x0000007ff7b76444 libhostfxr.so`fx_muxer_t::execute(host_command=<unavailable>, argc=1, argv=0x0000007ffffffd68, host_info=0x0000007ffffff948, result_buffer=<unavailable>, buffer_size=0, required_buffer_size=<unavailable>) at fx_muxer.cpp:541:18
    frame #27: 0x0000007ff7b722a4 libhostfxr.so`::hostfxr_main_startupinfo(argc=<unavailable>, argv=<unavailable>, host_path=<unavailable>, dotnet_root=<unavailable>, app_path=<unavailable>) at hostfxr.cpp:33:12
    frame #28: 0x000000000040e6f4 myhello`exe_start(argc=1, argv=0x0000007ffffffd68) at corehost.cpp:220:18
    frame #29: 0x000000000040ea5c myhello`main(argc=<unavailable>, argv=<unavailable>) at corehost.cpp:287:21
    frame #30: 0x0000007ff7be03f8 libc.so.6`__libc_start_main(main=(myhello`main at corehost.cpp:269), argc=1, argv=0x0000007ffffffd68, init=<unavailable>, fini=<unavailable>, rtld_fini=<unavailable>, stack_end=<unavailable>) at libc-start.c:314:16
    frame #31: 0x0000000000403aa0 myhello`_start + 40
(lldb) clrstack
OS Thread Id: 0x80 (1)
        Child SP               IP Call Site
0000007FFFFFE318 0000007ff7fac330 [InlinedCallFrame: 0000007fffffe318] Interop+Sys.ReadStdin(Byte*, Int32)
0000007FFFFFE318 0000007f7e41054c [InlinedCallFrame: 0000007fffffe318] Interop+Sys.ReadStdin(Byte*, Int32)
0000007FFFFFE300 0000007F7E41054C ILStubClass.IL_STUB_PInvoke(Byte*, Int32)
0000007FFFFFE3B0 0000007F7E53B870 System.IO.StdInReader.ReadKey(Boolean ByRef) [/_/src/System.Console/src/System/IO/StdInReader.cs @ 395]
0000007FFFFFE910 0000007F7E53A7FC System.IO.StdInReader.ReadLine(Boolean) [/_/src/System.Console/src/System/IO/StdInReader.cs @ 100]
0000007FFFFFEA50 0000007F7E53A734 System.IO.StdInReader.ReadLine() [/_/src/System.Console/src/System/IO/StdInReader.cs @ 83]
0000007FFFFFEA60 0000007F7E5396F0 System.IO.SyncTextReader.ReadLine() [/_/src/System.Console/src/System/IO/SyncTextReader.cs @ 77]
0000007FFFFFEA90 0000007F7E52AA6C System.Console.ReadLine() [/_/src/System.Console/src/System/Console.cs @ 463]
0000007FFFFFEAA0 0000007F7E3F99E4 myhello.Program.Main(System.String[]) [/home/oldzhu/myhello/Program.cs @ 10]
0000007FFFFFEE18 0000007ff7565814 [GCFrame: 0000007fffffee18]
0000007FFFFFF318 0000007ff7565814 [Frame: 0000007ffffff318]
(lldb) f 14
frame #14: 0x0000007ff7579708 libcoreclr.so`RunMain(MethodDesc*, short, int*, PtrArray**) at assembly.cpp:1556
libcoreclr.so`RunMain:
    0x7ff7579708 <+616>: add    x0, sp, #0xf8             ; =0xf8
    0x7ff757970c <+620>: add    x1, sp, #0x80             ; =0x80
    0x7ff7579710 <+624>: mov    x2, xzr
    0x7ff7579714 <+628>: mov    w3, wzr
(lldb) source info
Lines found in module `libcoreclr.so
[0x0000007ff7579708-0x0000007ff7579708): /__w/1/s/src/vm/assembly.cpp:1556
(lldb)
~~~
8. Note there is no source code avaiable in the above debugging even after the symbols loaded, it is because that the new deployed self-contained .net core app is not using the .net core runtime built from the scratch. You can use the syncsrc.sh to sync the source code of the coreclr for the specific .net core runtime to the arm/arm64 VM image  so that you can use the coreclr in debugging:
~~~
 ~/vm_releases/04-04-2021/arm64/syncsrc.sh
~~~
After sync the source, terminate the current qemu process and start the new instance of the VM image by running start-qemu.sh, then you can get the coreclr part of the source code availabe as the below.
~~~
(lldb) f 14
frame #14: 0x0000007ff7579708 libcoreclr.so`RunMain(MethodDesc*, short, int*, PtrArray**) at assembly.cpp:1556
   1553         {
   1554             // Set the return value to 0 instead of returning random junk
   1555             *pParam->piRetVal = 0;
-> 1556             threadStart.Call(&stackVar);
   1557         }
   1558         else
   1559         {
libcoreclr.so`RunMain:
    0x7ff7579708 <+616>: add    x0, sp, #0xf8             ; =0xf8
    0x7ff757970c <+620>: add    x1, sp, #0x80             ; =0x80
    0x7ff7579710 <+624>: mov    x2, xzr
    0x7ff7579714 <+628>: mov    w3, wzr
(lldb) source info
Lines found in module `libcoreclr.so
[0x0000007ff7579708-0x0000007ff7579708): /__w/1/s/src/vm/assembly.cpp:1556
(lldb)
~~~
