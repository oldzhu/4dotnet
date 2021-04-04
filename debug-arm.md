The steps to debug .net core app using the arm VM 
for arm:
1. Build the arm VM by the steps [Build arm/arm64 VM (Linux + QEMU + GDB + LLDB + SOS + .NET Core runtime) for .NET core application debugging](build.md)  
    or  
    Download the latest released arm VM and extract the files to home folder. For example:
~~~
wget https://github.com/oldzhu/4dotnet/releases/download/v1.0.0/dotnet_arm_linux_vm_[dd-mm-yyyy].tar.gz
tar -xzvf dotnet_arm_linux_vm_[dd-mm-yyyy].tar.gz -C ~
~~~ 
2.  Start the VM by the below command.  
if vm is built by yourself:
~~~
~/4dotnet/scripts/arm/start-qemu.sh
~~~
if vm is donwloaded release:
~~~
~/vm_releases/[dd-mm-yyyy]/arm/start-qemu.sh
~~~
  
**replace the [dd-mm-yyyy] with the real date time you see in the latest github release if you prefer to use the release VM directly.**
  
3. Login as root without password
~~~
Welcome to Buildroot
buildroot login: root
qemu-system-arm: warning: 9p: degraded performance: a reasonable high msize should be chosen on client/guest side (chosen msize is <= 8192). See https://wiki.qemu.org/Documentation/9psetup#msize for details.
#
~~~
**you won't hit the illegal instruction if you use the rlease arm VM directly as the release arm VM was already patched**
  
**so skip the step 4 to 10 and start from the setp 11 to enjoy the debugging if the release arm VM is used** 
  
4. Run lldb to debug the demo dotnethello application.
~~~
# lldb dotnethello/dotnethello
(lldb) target create "dotnethello/dotnethello"
Current executable set to '/root/dotnethello/dotnethello' (arm).
(lldb) r
Process 184 launched: '/root/dotnethello/dotnethello' (arm)
Process 184 stopped and restarted: thread 1 received signal: SIGCHLD
Process 184 stopped and restarted: thread 1 received signal: SIGCHLD
Process 184 stopped
* thread #1, name = 'dotnethello', stop reason = signal SIGILL: illegal instruction
    frame #0: 0x6e4582d2
->  0x6e4582d2: strhmi lr, [r0], -sp
    0x6e4582d6: ldrbmi r11, [r0, -r1]!
    0x6e4582da: strlt  r0, [r3], #-0
    0x6e4582de: .long  0xf89db51c                ; unknown opcode
(lldb)
~~~
5. Disassemble the current illegal instruction with the raw bytes displayed (0x4000e8bd).  
~~~
(lldb) disas -b -m -p -c 1
->  0x6dc522d2: 0x4000e8bd   strhmi lr, [r0], -sp
(lldb)
~~~
6. Run bt and clrstack to check the stack frames of illegal instruction.
~~~
(lldb) bt
* thread #1, name = 'dotnethello', stop reason = signal SIGILL: illegal instruction
  * frame #0: 0x6e4582d2
    frame #1: 0x6ee5fba2
    frame #2: 0x6ee5f78c
    frame #3: 0x6ee5f2f4
    frame #4: 0x6ee681e8
(lldb) clrstack
Error: Failed to find runtime directory
SOSInitializeByHost failed 80004002
OS Thread Id: 0xb8 (1)
Child SP       IP Call Site
7EFFF100 6E4582D2 System.Reflection.Metadata.AssemblyDefinitionHandle.op_Implicit(System.Reflection.Metadata.AssemblyDefinitionHandle)
7EFFF108 6E457992 System.Reflection.Metadata.AssemblyDefinition.GetCustomAttributes()
7EFFF130 6EE5FBA2 System.Diagnostics.FileVersionInfo.LoadManagedAssemblyMetadata(System.Reflection.Metadata.MetadataReader, Boolean)
7EFFF198 6EE5F78C System.Diagnostics.FileVersionInfo.TryLoadManagedAssemblyMetadata()
7EFFF240 6EE5F2F4 System.Diagnostics.FileVersionInfo.GetVersionInfo(System.String)
7EFFF258 6EE681E8 dotnethello.Program.Main(System.String[])
(lldb)
~~~
7. Quit from lldb and switch to gdb to debug the illegal instruction.
~~~
# gdb dotnethello/dotnethello
GNU gdb (GDB) 10.1
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "arm-buildroot-linux-gnueabihf".
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
Using host libthread_db library "/lib/libthread_db.so.1".
[New Thread 0x766173d0 (LWP 283)]
[New Thread 0x75cff3d0 (LWP 284)]
[New Thread 0x752ff3d0 (LWP 285)]
[New Thread 0x748ff3d0 (LWP 286)]
[New Thread 0x740fe3d0 (LWP 287)]
[New Thread 0x738fd3d0 (LWP 288)]
[New Thread 0x700fb3d0 (LWP 289)]
[New Thread 0x74afe3d0 (LWP 290)]
[New Thread 0x6ed6f3d0 (LWP 291)]
[New Thread 0x6e56e3d0 (LWP 292)]
[New Thread 0x6e41e3d0 (LWP 293)]
[New Thread 0x6bc513d0 (LWP 294)]

Thread 1 "dotnethello" received signal SIGILL, Illegal instruction.
Dump of assembler code from 0x6e4572d2 to 0x6e4572da:
=> 0x6e4572d2:  bd e8 00 40     ldmia.w sp!, {lr}
   0x6e4572d6:  01 b0   add     sp, #4
   0x6e4572d8:  70 47   bx      lr
End of assembler dump.
0x6e4572d2 in ?? ()

(gdb)
~~~
8. Note lldb and gdb disassemble the same raw bytes 0x4000e8bd as different arm instruction. Seems our lldb does not work well to  disassemble the arm instruction and that's why sometimes it is necessary to use both lldb and gdb for debugging.  
lldb + sos plugin to check the managed part of the target.  
gdb to dissaemble the insuructions in case lldb does not work well to disassemble   

lldb
~~~
(lldb) disas -b -m -p -c 1
->  0x6dc522d2: 0x4000e8bd   strhmi lr, [r0], -sp
(lldb)
~~~   
gdb
~~~
(gdb) disas /rs $pc,+1
Dump of assembler code from 0x6e4502d2 to 0x6e4502d3:
=> 0x6e4502d2:  bd e8 00 40     ldmia.w sp!, {lr}
End of assembler dump.
(gdb) x /x $pc
0x6e4502d2:     0x4000e8bd
(gdb)
~~~
9. The issue for the above illegal instruction described as the below  
[SIGILL's on ARM32 while using valgrind #33727](https://github.com/dotnet/runtime/issues/33727)
10. there are two workarounds to fix the issue

    1. rebuild the .net core runtime with PublishReadyToRun=false[workaround4illegalinstruction.md] 

    or

    2. patch the emitarm.cpp with the POC patch[pocpatch4illegalinstruction.md]

11. then you can start the debugging trip without the crash.
~~~
# lldb dotnethello/dotnethello
(lldb) target create "dotnethello/dotnethello"
Current executable set to '/root/dotnethello/dotnethello' (arm).
(lldb) r
Process 184 launched: '/root/dotnethello/dotnethello' (arm)
Process 184 stopped and restarted: thread 1 received signal: SIGCHLD
Process 184 stopped and restarted: thread 1 received signal: SIGCHLD
Hello World from .NET 6.0.0-dev
The location is /root/dotnethello/System.Private.CoreLib.dll
press anykey to exit...
Process 184 stopped
* thread #1, name = 'dotnethello', stop reason = signal SIGSTOP
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
(lldb) clrstack
Error: Failed to find runtime directory
SOSInitializeByHost failed 80004002
OS Thread Id: 0xb8 (1)
Child SP       IP Call Site
7EFFEC34 76fb46fc [InlinedCallFrame: 7effec34]
7EFFEC34 6d43430e [InlinedCallFrame: 7effec34] Interop+Sys.ReadStdin(Byte*, Int32)
7EFFEC30 6D43430E ILStubClass.IL_STUB_PInvoke(Byte*, Int32)
7EFFEC80 6D43429A System.IO.StdInReader.ReadStdin(Byte*, Int32)
7EFFF0B8 6d434018 [InlinedCallFrame: 7efff0b8]
7EFFECA8 6D434018 System.IO.StdInReader.ReadKey(Boolean ByRef)
7EFFF168 6d433b04 [InlinedCallFrame: 7efff168]
7EFFF160 6D433B04 System.IO.StdInReader.ReadLineCore(Boolean)
7EFFF1F0 6D433A20 System.IO.StdInReader.ReadLine()
7EFFF210 6D4339A8 System.IO.SyncTextReader.ReadLine()
7EFFF240 6D432C44 System.Console.ReadLine()
7EFFF258 6EE6892C dotnethello.Program.Main(System.String[])
(lldb) bt
* thread #1, name = 'dotnethello', stop reason = signal SIGSTOP
  * frame #0: 0x76fb46fc libpthread.so.0`__libc_read at read.c:26:10
    frame #1: 0x76fb46e4 libpthread.so.0`__libc_read(fd=0, buf=0x7effecb0, nbytes=1024) at read.c:24
    frame #2: 0x6ee3b150 libSystem.Native.so`SystemNative_ReadStdin(buffer=0x7effecb0, bufferSize=1024) at pal_console.c:403:37
    frame #3: 0x6d43430e
    frame #4: 0x6d43429a
    frame #5: 0x6d434018
    frame #6: 0x6d433b04
    frame #7: 0x6d433a20
    frame #8: 0x6d4339a8
    frame #9: 0x6d432c44
    frame #10: 0x6ee6892c
    frame #11: 0x769ac166 libcoreclr.so`CallDescrWorkerInternal at asmhelpers.S:78
(lldb) f 2
frame #2: 0x6ee3b150 libSystem.Native.so`SystemNative_ReadStdin(buffer=0x7effecb0, bufferSize=1024) at pal_console.c:403:37
   400      }
   401
   402      ssize_t count;
-> 403      while (CheckInterrupted(count = read(STDIN_FILENO, buffer, Int32ToSizeT(bufferSize))));
                                            ^
   404      return (int32_t)count;
   405  }
   406
libSystem.Native.so`SystemNative_ReadStdin:
->  0x6ee3b150 <+20>: mov    r6, r0
    0x6ee3b152 <+22>: cmp.w  r0, #0xffffffff
    0x6ee3b156 <+26>: bgt    0x6ee3b162                ; <+38> at pal_console.c:405:1
    0x6ee3b158 <+28>: blx    0x6ee35aec                ; symbol stub for: inotify_init
(lldb)
~~~