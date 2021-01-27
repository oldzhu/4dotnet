The steps to debug .net core app using the built arm VM  
for arm:
1. Build the arm VM as [Build arm/arm64 VM (Linux + QEMU + GDB + LLDB + SOS + .NET Core runtime) for .NET core application debugging](build.md)  
    or  
    Download the released VM with some packaged sources.  
2.  Start the VM by the below command。
~~~
~/4dotnet/scripts/arm/start-qemu.sh
~~~
3. Login as root without password
~~~
Welcome to Buildroot
buildroot login: root
qemu-system-arm: warning: 9p: degraded performance: a reasonable high msize should be chosen on client/guest side (chosen msize is <= 8192). See https://wiki.qemu.org/Documentation/9psetup#msize for details.
#
~~~
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

    1. publish the demo dotnethello program with PublishReadyToRun=false
    
    or

    2. patch the emitarm.cpp with the POC patch