How to publish a .netcore app to the arm/arm64 vm.  

if you build the arm/arm64 vm using the steps [Build arm/arm64 VM (Linux + GDB + LLDB + SOS + .NET Core applcation)](build.md) from scratch,  
you can use vi or vscode to modify the dotnethello source which is ~/buildroot/output/build/dotnethello-1.0/Program.cs to add your customize code,  
then run the below command to rebuild the dotnethello and the new system image for debugging.  
~~~
        export PATH=`echo $PATH|tr -d ' '`
        make dotnethello-rebuild all
~~~  

If you download and use the release arm/arm64 vm directly, refer the below steps to publish a .netcore app with the released .net core runtime to the VM image to debug:  
The steps is similiar as  [Deploy self-contained .NET apps to Raspberry Pi](https://docs.microsoft.com/en-us/dotnet/iot/deployment#deploying-a-self-contained-app).
1. Install the .NET core you want to test in WSL2 if you haven't.
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
Welcome to Buildroot
buildroot login: root
# lldb myhello/myhello
(lldb) target create "myhello/myhello"
Current executable set to '/root/myhello/myhello' (arm).
(lldb) r
error: failed to get reply to handshake packet
(lldb) r
error: failed to get reply to handshake packet
(lldb) r
Process 200 launched: '/root/myhello/myhello' (arm)
Process 200 stopped and restarted: thread 1 received signal: SIGCHLD
Process 200 stopped and restarted: thread 1 received signal: SIGCHLD
Hello World!
Process 200 stopped
* thread #1, name = 'myhello', stop reason = signal SIGSTOP
    frame #0: 0x76fb46fc libpthread.so.0`__libc_read at read.c:26:10
   23   ssize_t
   24   __libc_read (int fd, void *buf, size_t nbytes)
   25   {
-> 26     return SYSCALL_CANCEL (read, fd, buf, nbytes);
                 ^
   27   }
   28   libc_hidden_def (__libc_read)
   29
libpthread.so.0`__libc_read:
->  0x76fb46fc <+84>: svc    #0x0
    0x76fb4700 <+88>: cmn    r0, #4096
    0x76fb4704 <+92>: mov    r4, r0
    0x76fb4708 <+96>: ldrhi  r2, [pc, #0x34]           ; <+156> at read.c:26:10
(lldb) sethostruntime /root/dotnethello
Using .NET Core runtime to host the managed SOS code
Host runtime path: /root/dotnethello
(lldb) setsymbolserver -ms
Added Microsoft public symbol server
(lldb) loadsymbols
(lldb) bt
* thread #1, name = 'myhello', stop reason = signal SIGSTOP
  * frame #0: 0x76fb46fc libpthread.so.0`__libc_read at read.c:26:10
    frame #1: 0x76fb46e4 libpthread.so.0`__libc_read(fd=0, buf=0x7effef20, nbytes=1024) at read.c:24
    frame #2: 0x6e3f6adc System.Native.so`SystemNative_ReadStdin(buffer=<unavailable>, bufferSize=<unavailable>) at pal_console.c:393:37
    frame #3: 0x6bc33ff4
    frame #4: 0x6e483cee
    frame #5: 0x6e483140
    frame #6: 0x6e4830c0
    frame #7: 0x6e4766ee
    frame #8: 0x6e4c2890
(lldb) clrstack
OS Thread Id: 0xc8 (1)
Child SP       IP Call Site
7EFFEECC 76fb46fc [InlinedCallFrame: 7effeecc]
7EFFEECC 6bc33ff4 [InlinedCallFrame: 7effeecc] Interop+Sys.ReadStdin(Byte*, Int32)
7EFFEEC8 6BC33FF4 ILStubClass.IL_STUB_PInvoke(Byte*, Int32)
7EFFEF18 6E483CEE System.IO.StdInReader.ReadKey(Boolean ByRef) [/_/src/System.Console/src/System/IO/StdInReader.cs @ 395]
7EFFF3B8 6E483140 System.IO.StdInReader.ReadLine(Boolean) [/_/src/System.Console/src/System/IO/StdInReader.cs @ 100]
7EFFF450 6E4830C0 System.IO.StdInReader.ReadLine() [/_/src/System.Console/src/System/IO/StdInReader.cs @ 83]
7EFFF458 6E4823E2 System.IO.SyncTextReader.ReadLine() [/_/src/System.Console/src/System/IO/SyncTextReader.cs @ 77]
7EFFF478 6E4766EE System.Console.ReadLine() [/_/src/System.Console/src/System/Console.cs @ 463]
7EFFF488 6E4C2890 myhello.Program.Main(System.String[]) [/home/oldzhu/myhello/Program.cs @ 10]
7EFFF60C 767d9466 [GCFrame: 7efff60c]
7EFFF9A0 767d9466 [GCFrame: 7efff9a0]
(lldb) f 2
frame #2: 0x6e3f6adc System.Native.so`SystemNative_ReadStdin(buffer=<unavailable>, bufferSize=<unavailable>) at pal_console.c:393:37
System.Native.so`SystemNative_ReadStdin:
->  0x6e3f6adc <+24>: mov    r6, r0
    0x6e3f6ade <+26>: cmp.w  r6, #0xffffffff
    0x6e3f6ae2 <+30>: bgt    0x6e3f6afc                ; <+56> at pal_console.c:395:1
    0x6e3f6ae4 <+32>: blx    0x6e3f5d3c                ; symbol stub for: __errno_location
(lldb) source info
Lines found in module `System.Native.so
[0x6e3f6ad2-0x6e3f6ade): /__w/1/s/src/Native/Unix/System.Native/pal_console.c:393:37
~~~
***note the I didn't sethostruntime to /root/myhello as the below exampel for arm64 but set it to /root/dotnethello for arm example, do you know why?***
In addtion, for arm as teh below you would find still can't see the source info for libcoreclr.so which is not like for arm64 even after run loadsymbols, this looks like the similar issue as [dotnet-trace does not resolve symbols on linux-arm #2003](https://github.com/dotnet/diagnostics/issues/2003) which need to work out. 

for arm example (libcoreclr.so):
~~~
(lldb) t 5
(lldb) * thread #5, name = 'myhello'
    frame #0: 0x76fb4ec8 libpthread.so.0`__libc_open(file="@5\U00000015\xe5", oflag=0) at open.c:44:10
   41         va_end (arg);
   42       }
   43
-> 44     return SYSCALL_CANCEL (openat, AT_FDCWD, file, oflag, mode);
                 ^
   45   }
   46   libc_hidden_def (__libc_open)
   47
libpthread.so.0`__libc_open:
->  0x76fb4ec8 <+172>: svc    #0x0
    0x76fb4ecc <+176>: cmn    r0, #4096
    0x76fb4ed0 <+180>: mov    r4, r0
    0x76fb4ed4 <+184>: ldrhi  r3, [pc, #0x30]           ; <+240> at open.c:44:10
bt
* thread #5, name = 'myhello'
  * frame #0: 0x76fb4ec8 libpthread.so.0`__libc_open(file="@5\U00000015\xe5", oflag=0) at open.c:44:10
    frame #1: 0x768e8b94 libcoreclr.so`TwoWayPipe::WaitForConnection() + 24
    frame #2: 0x768dceaa libcoreclr.so`DbgTransportSession::TransportWorker() + 126
    frame #3: 0x768dc122 libcoreclr.so`DbgTransportSession::TransportWorkerStatic(void*) + 8
    frame #4: 0x7698acd2 libcoreclr.so`CorUnix::CPalThread::ThreadEntry(void*) + 342
    frame #5: 0x76fa8e08 libpthread.so.0`start_thread(arg=0x748fe3d0) at pthread_create.c:463:8
    (lldb) f 1
frame #1: 0x768e8b94 libcoreclr.so`TwoWayPipe::WaitForConnection() + 24
libcoreclr.so`TwoWayPipe::WaitForConnection:
->  0x768e8b94 <+24>: str    r0, [r4, #0x4]
    0x768e8b96 <+26>: adds   r0, #0x1
    0x768e8b98 <+28>: beq    0x768e8bb0                ; <+52>
    0x768e8b9a <+30>: add.w  r0, r4, #0x110
(lldb) source info
error: No debug info for the selected frame.
(lldb)
~~~
based on the below output, suspect the symbol for libcoreclr.so is not published for linux-arm so that it can't be located.
~~~
(lldb) image list
[  0] 09FB0A33-CDF4-D4B5-803D-E076BDD1291F-C6380370 0x00008000 /root/myhello/myhello
      /root/.dotnet/symbolcache/_.debug/elf-buildid-sym-09fb0a33cdf4d4b5803de076bdd1291fc6380370/_.debug
[  1] D104EE88 0x76fcc000 /lib/ld-2.32.so
[  2] 3374B213-D499-019F-863C-E562EDA15D30-8EC5D06B 0x76ffd000 [vdso] (0x0000000076ffd000)
[  3] AABF9974 0x76ffd000 linux-vdso.so.1 (0x0000000076ffd000)
[  4] 4781D472 0x76fa3000 /lib/libpthread.so.0
[  5] 5A28B0CD 0x76f90000 /lib/libdl.so.2
[  6] AB9275CC 0x76e53000 /usr/lib/libstdc++.so.6
[  7] DFE402F0 0x76de7000 /lib/libm.so.6
[  8] 8F3E7BED 0x76db9000 /lib/libgcc_s.so.1
[  9] 5FB2EE16 0x76c73000 /lib/libc.so.6
[ 10] 395938F5-CAC9-A90F-0147-35054D3B687A-D2D4F0A3 0x76c25000 /root/myhello/libhostfxr.so
      /root/.dotnet/symbolcache/_.debug/elf-buildid-sym-395938f5cac9a90f014735054d3b687ad2d4f0a3/_.debug
[ 11] B196731E-F28B-14EC-BFAE-4C14CFF41024-137E690F 0x76bdf000 /root/myhello/libhostpolicy.so
      /root/.dotnet/symbolcache/_.debug/elf-buildid-sym-b196731ef28b14ecbfae4c14cff41024137e690f/_.debug
[ 12] B22390F5-129E-4694-7ECC-73B893ED9E7F-001B33AD 0x76666000 /root/myhello/libcoreclr.so
[ 13] 0640E910 0x7664f000 /lib/librt.so.1
[ 14] 66C2F092-8EF1-9617-602A-14FCFB2AD010-66DC3B7D 0x765cf000 /root/myhello/libcoreclrtraceptprovider.so
      /root/.dotnet/symbolcache/_.debug/elf-buildid-sym-66c2f0928ef19617602a14fcfb2ad01066dc3b7d/_.debug
[ 15] E4661459 0x7655e000 /usr/lib/liblttng-ust.so.0
[ 16] 1DFA7934 0x7653d000 /usr/lib/liblttng-ust-tracepoint.so.0
[ 17] 9FA41BA2 0x76526000 /usr/lib/liburcu-bp.so.6
[ 18] 3949A303 0x7650e000 /usr/lib/liburcu-cds.so.6
[ 19] C0513F3C 0x764fa000 /usr/lib/liburcu-common.so.6
[ 20] EDB1C93B-0BC1-8995-AE68-3E5D2D641F88-655E4876 0x6e4cb000 /root/myhello/libclrjit.so
      /root/.dotnet/symbolcache/_.debug/elf-buildid-sym-edb1c93b0bc18995ae683e5d2d641f88655e4876/_.debug
[ 21] DB6193C8-E062-C692-57A9-4388F26798C9-6585643A 0x6e3f2000 /root/myhello/System.Native.so
      /root/.dotnet/symbolcache/_.debug/elf-buildid-sym-db6193c8e062c69257a94388f26798c96585643a/_.debug
[ 22] 6559CC5C-8F62-34D1-4CBB-DF762DA087C1-76C540CD 0x6e3d4000 /root/myhello/System.Globalization.Native.so
      /root/.dotnet/symbolcache/_.debug/elf-buildid-sym-6559cc5c8f6234d14cbbdf762da087c176c540cd/_.debug
[ 23] A1E235A4 0x6e25e000 /usr/lib/libicuuc.so.68
[ 24] 8DF0C512 0x6c70e000 /usr/lib/libicudata.so.68
[ 25] E00D3A0B 0x6c6f7000 /lib/libatomic.so.1
[ 26] 1580547C 0x6c4b3000 /usr/lib/libicui18n.so.68
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
8. Note there is no source code avaiable in the above debugging even after the symbols loaded, it is because that the new deployed self-contained .net core app is not using the .net core runtime built from the scratch. You can use the syncsrc.sh to sync the source code of the coreclr for the specific .net core runtime to the arm/arm64 VM image so that you can use the coreclr in debugging:
for arm
~~~
 ~/vm_releases/04-04-2021/arm/syncsrc.sh
~~~
for arm64
~~~
 ~/vm_releases/04-04-2021/arm64/syncsrc.sh
~~~
After sync the source, exit the current qemu session by press CTRL+a then press x, and start the new instance of the VM image by running start-qemu.sh, then you can get the coreclr part of the source code availabe as the below.
for arm example:
~~~
still no source avaiale as the above symbol issue...
~~~
for arm64 example:
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
if run syncsrc.sh without parameter, then syncsrc.sh will sync the coreclr source for the .netcore runtime which is used by default in WSL2 host.
you also can run syncsrc.sh as the below to sync the coreclr source for the specific version .netcore runtime.
~~~ 
syncsrc.sh [version] [commithash] 
~~~
for example:
~~~

~~~