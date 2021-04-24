The steps to debug .net core app using the built arm64 VM  
for arm64:
1. Build the arm64 VM as [Build arm/arm64 VM (Linux + QEMU + GDB + LLDB + SOS + .NET Core runtime) for .NET core application debugging](build.md)  
    or  
    Download the latest released arm VM and extract the files to home folder. For example:
~~~
wget https://github.com/oldzhu/4dotnet/releases/download/v1.0.0/dotnet_arm64_linux_vm_[dd-mm-yyyy].tar.gz
tar -xzvf dotnet_arm64_linux_vm_[dd-mm-yyyy].tar.gz -C ~
~~~  
2.  Start the VM by the below command.  
if vm is built by yourself:
~~~
~/4dotnet/scripts/arm64/start-qemu.sh
~~~  
if vm is donwloaded release:
~~~
~/vm_releases/[dd-mm-yyyy]/arm64/start-qemu.sh
~~~
**replace the [dd-mm-yyyy] with the real date time you see in the latest github release if you prefer to use the release VM directly.**  
if see the below error when start the release VM:
~~
vm_releases/04-04-2021/arm64/qemu-system-aarch64: error while loading shared libraries: libpixman-1.so.0: cannot open shared object file: No such file or directory
~~~
try to install libpixman-1-dev to fix
~~~
sudo apt install libpixman-1-dev
~~~    
3. Login as root without password
~~~
Welcome to Buildroot
buildroot login: root
qemu-system-aarch64: warning: 9p: degraded performance: a reasonable high msize should be chosen on client/guest side (chosen msize is <= 8192). See https://wiki.qemu.org/Documentation/9psetup#msize for details.
#
~~~
4. Run lldb to debug the demo dotnethello application.
~~~
# lldb ./dotnethello/dotnethello
(lldb) target create "./dotnethello/dotnethello"
Current executable set to '/root/dotnethello/dotnethello' (aarch64).
(lldb) r
Process 128 launched: '/root/dotnethello/dotnethello' (aarch64)
Process 128 stopped and restarted: thread 1 received signal: SIGCHLD
Process 128 stopped and restarted: thread 1 received signal: SIGCHLD
Hello World from .NET 6.0.0-dev
The location is /root/dotnethello/System.Private.CoreLib.dll
press anykey to exit...
~~~
5. Press CTRL+c to break into the lldb.
~~~
Process 128 stopped
* thread #1, name = 'dotnethello', stop reason = signal SIGSTOP
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
    0x7ff7fac33c <+124>: b.hi   0x7ff7fac374              ; <+180> [inlined] __libc_read at read.c:24
(lldb)
~~~
6. Display the native call stack of the currnt thread.
~~~
(lldb) bt
* thread #1, name = 'dotnethello', stop reason = signal SIGSTOP
  * frame #0: 0x0000007ff7fac330 libpthread.so.0`__libc_read at read.c:26:10
    frame #1: 0x0000007ff7fac318 libpthread.so.0`__libc_read(fd=<unavailable>, buf=0x0000007fffffe400, nbytes=1024) at read.c:24
    frame #2: 0x0000007ff31610b8 libSystem.Native.so`SystemNative_ReadStdin(buffer=0x0000007fffffe400, bufferSize=1024) at pal_console.c:403:37
    frame #3: 0x0000007f7e52aca8
    frame #4: 0x0000007f7e647a2c
    frame #5: 0x0000007f7e646d28
    frame #6: 0x0000007f7e64690c
    frame #7: 0x0000007f7e645b10
    frame #8: 0x0000007f7e637b4c
    frame #9: 0x0000007f7e4fe12c
    frame #10: 0x0000007ff7791208 libcoreclr.so`CallDescrWorkerInternal at calldescrworkerarm64.S:71
    frame #11: 0x0000007ff761ffd4 libcoreclr.so`MethodDescCallSite::CallTargetWorker(unsigned long const*, unsigned long*, int) at callhelpers.cpp:71:5
    frame #12: 0x0000007ff761ff7c libcoreclr.so`MethodDescCallSite::CallTargetWorker(this=0x000000555562a800, pArguments=0x0000000000000001, pReturnValue=0x0000000000000000, cbReturnValue=0) at callhelpers.cpp:548
    frame #13: 0x0000007ff75089c8 libcoreclr.so`RunMain(MethodDesc*, short, int*, PtrArray**) [inlined] MethodDescCallSite::Call(this=0x0000007fffffef28, pArguments=0x0000007fffffeec0) at callhelpers.h:458:9
    frame #14: 0x0000007ff75089b4 libcoreclr.so`RunMain(MethodDesc*, short, int*, PtrArray**) at assembly.cpp:1464
    frame #15: 0x0000007ff7508878 libcoreclr.so`RunMain(MethodDesc*, short, int*, PtrArray**) [inlined] RunMain(this=<unavailable>, pParam=0x0000007fffffee88)::$_0::operator()(Param*) const::'lambda'(Param*)::operator()(Param*) const at assembly.cpp:1536
    frame #16: 0x0000007ff7508878 libcoreclr.so`RunMain(MethodDesc*, short, int*, PtrArray**) at assembly.cpp:1538
    frame #17: 0x0000007ff750883c libcoreclr.so`RunMain(pFD=<unavailable>, numSkipArgs=<unavailable>, piRetVal=<unavailable>, stringArgs=<unavailable>) at assembly.cpp:1538
    frame #18: 0x0000007ff7508cc0 libcoreclr.so`Assembly::ExecuteMainMethod(this=0x00000055555e20e0, stringArgs=0x0000007ffffff308, waitForOtherThreads=YES) at assembly.cpp:1648:18
    frame #19: 0x0000007ff7540734 libcoreclr.so`CorHost2::ExecuteAssembly(this=<unavailable>, dwAppDomainId=<unavailable>, pwzAssemblyPath=<unavailable>, argc=<unavailable>, argv=0x0000000000000000, pReturnValue=0x0000007ffffff488) at corhost.cpp:384:39
    frame #20: 0x0000007ff74f40a4 libcoreclr.so`::coreclr_execute_assembly(hostHandle=0x00000055555ee180, domainId=1, argc=0, argv=<unavailable>, managedAssemblyPath=<unavailable>, exitCode=0x0000007ffffff488) at unixinterface.cpp:446:24
    frame #21: 0x0000007ff7b24a58 libhostpolicy.so`run_app_for_context(context=<unavailable>, argc=<unavailable>, argv=<unavailable>) at hostpolicy.cpp:249:32
    frame #22: 0x0000007ff7b24e34 libhostpolicy.so`run_app(argc=0, argv=0x0000007ffffffd60) at hostpolicy.cpp:284:12
    frame #23: 0x0000007ff7b257fc libhostpolicy.so`::corehost_main(argc=<unavailable>, argv=<unavailable>) at hostpolicy.cpp:430:12
    frame #24: 0x0000007ff7b73d98 libhostfxr.so`fx_muxer_t::handle_exec_host_command(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, host_startup_info_t const&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::unordered_map<known_options, std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >, known_options_hash, std::equal_to<known_options>, std::allocator<std::pair<known_options const, std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > > > > const&, int, char const**, int, host_mode_t, char*, int, int*) at fx_muxer.cpp:146:20
    frame #25: 0x0000007ff7b73b94 libhostfxr.so`fx_muxer_t::handle_exec_host_command(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, host_startup_info_t const&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, std::unordered_map<known_options, std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > >, known_options_hash, std::equal_to<known_options>, std::allocator<std::pair<known_options const, std::vector<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::allocator<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > > > > const&, int, char const**, int, host_mode_t, char*, int, int*) [inlined] (anonymous namespace)::read_config_and_execute(host_command=<unavailable>, host_info=<unavailable>, app_candidate=<unavailable>, opts=0x0000007ffffff868, new_argc=1, new_argv=0x0000007ffffffd58, mode=apphost, out_buffer=<unavailable>, buffer_size=<unavailable>, required_buffer_size=<unavailable>) at fx_muxer.cpp:520
    frame #26: 0x0000007ff7b73ab4 libhostfxr.so`fx_muxer_t::handle_exec_host_command(host_command=<unavailable>, host_info=<unavailable>, app_candidate=error: summary string parsing error, opts=0x0000007ffffff868, argc=<unavailable>, argv=<unavailable>, argoff=<unavailable>, mode=apphost, result_buffer=0x0000000000000000, buffer_size=0, required_buffer_size=0x0000000000000000) at fx_muxer.cpp:1001
    frame #27: 0x0000007ff7b72eb0 libhostfxr.so`fx_muxer_t::execute(host_command=error: summary string parsing error, argc=1, argv=0x0000007ffffffd58, host_info=0x0000007ffffff998, result_buffer=0x0000000000000000, buffer_size=0, required_buffer_size=0x0000000000000000) at fx_muxer.cpp:566:18
    frame #28: 0x0000007ff7b706f0 libhostfxr.so`::hostfxr_main_startupinfo(argc=1, argv=0x0000007ffffffd58, host_path=0x0000005555584ec0, dotnet_root=0x0000005555583eb0, app_path=<unavailable>) at hostfxr.cpp:60:12
    frame #29: 0x000000555555d184 dotnethello`___lldb_unnamed_symbol128$$dotnethello + 1028
    frame #30: 0x000000555555d444 dotnethello`___lldb_unnamed_symbol129$$dotnethello + 144
    frame #31: 0x0000007ff7be03f8 libc.so.6`__libc_start_main(main=(dotnethello`___lldb_unnamed_symbol129$$dotnethello), argc=1, argv=0x0000007ffffffd58, init=<unavailable>, fini=<unavailable>, rtld_fini=<unavailable>, stack_end=<unavailable>) at libc-start.c:314:16
~~~
7. Swicth between the different frames, not only the source of the .NET core runtime can be displayed but also the source of the linux .so libaries used. 
~~~
(lldb) f 11
frame #11: 0x0000007ff761ffd4 libcoreclr.so`MethodDescCallSite::CallTargetWorker(unsigned long const*, unsigned long*, int) at callhelpers.cpp:71:5
   68
   69       BEGIN_CALL_TO_MANAGEDEX(fCriticalCall ? EEToManagedCriticalCall : EEToManagedDefault);
   70
-> 71       CallDescrWorker(pCallDescrData);
            ^
   72
   73       END_CALL_TO_MANAGED();
   74   }
libcoreclr.so`MethodDescCallSite::CallTargetWorker:
->  0x7ff761ffd4 <+808>: ldur   x8, [x29, #-0xa0]
    0x7ff761ffd8 <+812>: cbz    x8, 0x7ff761ffe4          ; <+824> at pal.h
    0x7ff761ffdc <+816>: ldur   x9, [x29, #-0x98]
    0x7ff761ffe0 <+820>: str    x9, [x8]
(lldb) f 31
frame #31: 0x0000007ff7be03f8 libc.so.6`__libc_start_main(main=(dotnethello`___lldb_unnamed_symbol129$$dotnethello), argc=1, argv=0x0000007ffffffd58, init=<unavailable>, fini=<unavailable>, rtld_fini=<unavailable>, stack_end=<unavailable>) at libc-start.c:314:16
   311        THREAD_SETMEM (self, cleanup_jmp_buf, &unwind_buf);
   312
   313        /* Run the program.  */
-> 314        result = main (argc, argv, __environ MAIN_AUXVEC_PARAM);
                       ^
   315      }
   316    else
   317      {
libc.so.6`__libc_start_main:
->  0x7ff7be03f8 <+232>: bl     0x7ff7bf5250              ; __GI_exit at exit.c:138:1
    0x7ff7be03fc <+236>: ldr    x0, [sp, #0x58]
    0x7ff7be0400 <+240>: ldr    x2, [x2, #0x230]
    0x7ff7be0404 <+244>: ldr    x1, [x0]
(lldb)
~~~
8. Run sos command to list the managed stack frames.
~~~
(lldb) clrstack
OS Thread Id: 0x80 (1)
        Child SP               IP Call Site
0000007FFFFFE368 0000007ff7fac330 [InlinedCallFrame: 0000007fffffe368] Interop+Sys.ReadStdin(Byte*, Int32)
0000007FFFFFE368 0000007f7e52aca8 [InlinedCallFrame: 0000007fffffe368] Interop+Sys.ReadStdin(Byte*, Int32)
0000007FFFFFE350 0000007F7E52ACA8 ILStubClass.IL_STUB_PInvoke(Byte*, Int32)
0000007FFFFFE400 0000007F7E647A2C System.IO.StdInReader.ReadKey(Boolean ByRef)
0000007FFFFFE960 0000007F7E646D28 System.IO.StdInReader.ReadLineCore(Boolean)
0000007FFFFFEAA0 0000007F7E64690C System.IO.StdInReader.ReadLine()
0000007FFFFFEAD0 0000007F7E645B10 System.IO.SyncTextReader.ReadLine()
0000007FFFFFEB00 0000007F7E637B4C System.Console.ReadLine()
0000007FFFFFEB10 0000007F7E4FE12C dotnethello.Program.Main(System.String[])
(lldb)
~~~
9. Using the gdb to debug the same applciation but only can see native part.
~~~
# gdb dotnethello/dotnethello
GNU gdb (GDB) 10.1
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "aarch64-buildroot-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from dotnethello/dotnethello...
(No debugging symbols found in dotnethello/dotnethello)
(gdb) r
Starting program: /root/dotnethello/dotnethello
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".
[New Thread 0x7ff72aa130 (LWP 206)]
[New Thread 0x7ff6aa9130 (LWP 207)]
[New Thread 0x7ff62a8130 (LWP 208)]
[New Thread 0x7ff5a98130 (LWP 209)]
[New Thread 0x7ff5271130 (LWP 210)]
[New Thread 0x7ff4a6a130 (LWP 211)]
[New Thread 0x7ff3c3b130 (LWP 212)]
[New Thread 0x7ff31c4130 (LWP 213)]
[New Thread 0x7ff313e130 (LWP 214)]
[New Thread 0x7ff2937130 (LWP 215)]
[New Thread 0x7ff28f0130 (LWP 216)]
[New Thread 0x7feff28130 (LWP 217)]
[New Thread 0x7f7d88a130 (LWP 218)]
Hello World from .NET 6.0.0-dev
The location is /root/dotnethello/System.Private.CoreLib.dll
press anykey to exit...

Thread 1 "dotnethello" received signal SIGINT, Interrupt.
__libc_read (nbytes=1024, buf=0x7fffffe3e0, fd=<optimized out>)
    at ../sysdeps/unix/sysv/linux/read.c:26
26        return SYSCALL_CANCEL (read, fd, buf, nbytes);
(gdb) bt
#0  __libc_read (nbytes=1024, buf=0x7fffffe3e0, fd=<optimized out>)
    at ../sysdeps/unix/sysv/linux/read.c:26
#1  __libc_read (fd=<optimized out>, buf=buf@entry=0x7fffffe3e0,
    nbytes=nbytes@entry=1024) at ../sysdeps/unix/sysv/linux/read.c:24
#2  0x0000007ff31610b8 in SystemNative_ReadStdin (buffer=0x7fffffe3e0,
    bufferSize=1024)
    at /home/oldzhu/buildroot/output/build/dotnetruntime-origin_master/src/libraries/Native/Unix/System.Native/pal_console.c:403
#3  0x0000007f7e4fb228 in ?? ()
#4  0x0000007ff7a869f0 in vtable for InlinedCallFrame ()
   from /root/dotnethello/libcoreclr.so
Backtrace stopped: previous frame identical to this frame (corrupt stack?)
(gdb)
~~~
