# lldb sos plugin debugging
1. Start arm64 vm instance using the below command with the large memory (>=16G) and the tap networking set.
~~~
sudo $HOME/buildroot/output/host/bin/qemu-system-aarch64 -M virt -cpu cortex-a53 -nographic -smp 2 -m 16384 -kernel $HOME/buildroot/output/imag
es/Image -append "rootwait root=/dev/vda console=ttyAMA0" -netdev tap,id=eth0,script=$HOME/4dotnet/scripts/qemu-ifup,downscript=no -device virtio-net-device,netdev=eth0 -drive file=$HOME/buildroot/output/images/rootfs.ext4,if=none,format=raw,id=hd0 -device virtio-blk-device,drive=hd0 -fsdev local,id=v_9p_dev,path=$HOME/buildroot,security_model=none -device virtio-9p-device,fsdev=v_9p_dev,mount_tag=hostshare
~~~
2. Login and Run lldb to launch dotnethello in the arm64 qemu vm and waiting for debugging.
~~~
...
udhcpc: sending select for 192.168.53.76
udhcpc: lease of 192.168.53.76 obtained, lease time 3600
deleting routers
adding dns 192.168.53.1
OK
Starting ntpd: OK
random: crng init done
Starting sshd: OK

Welcome to Buildroot
buildroot login: root
qemu-system-aarch64: warning: 9p: degraded performance: a reasonable high msize should be chosen on client/guest side (chosen msize is <= 8192). See https://wiki.qemu.org/Documentation/9psetup#msize for details.
# lldb dotnethello/dotnethello
Using .NET Core runtime to host the managed SOS code
Host runtime path: /root/dotnethello
(lldb) target create "dotnethello/dotnethello"
Current executable set to '/root/dotnethello/dotnethello' (aarch64).
(lldb) r
Process 491 launched: '/root/dotnethello/dotnethello' (aarch64)
Hello World from .NET 6.0.0-dev
The location is /root/dotnethello/System.Private.CoreLib.dll
press anykey to exit...
Process 491 stopped
* thread #1, name = 'dotnethello', stop reason = signal SIGSTOP
    frame #0: 0x0000007ff7fac300 libpthread.so.0`__libc_read at read.c:26:10
   23   ssize_t
   24   __libc_read (int fd, void *buf, size_t nbytes)
   25   {
-> 26     return SYSCALL_CANCEL (read, fd, buf, nbytes);
                 ^
   27   }
   28   libc_hidden_def (__libc_read)
   29
libpthread.so.0`__libc_read:
->  0x7ff7fac300 <+112>: svc    #0
    0x7ff7fac304 <+116>: mov    x19, x0
    0x7ff7fac308 <+120>: cmn    x0, #0x1, lsl #12         ; =0x1000
    0x7ff7fac30c <+124>: b.hi   0x7ff7fac344              ; <+180> [inlined] __libc_read at read.c:26:10
(lldb) clrstack
OS Thread Id: 0x1eb (1)
        Child SP               IP Call Site
0000007FFFFFE348 0000007ff7fac300 [InlinedCallFrame: 0000007fffffe348] Interop+Sys.ReadStdin(Byte*, Int32)
0000007FFFFFE348 0000007f7e5255c8 [InlinedCallFrame: 0000007fffffe348] Interop+Sys.ReadStdin(Byte*, Int32)
0000007FFFFFE330 0000007F7E5255C8 ILStubClass.IL_STUB_PInvoke(Byte*, Int32)
0000007FFFFFE3E0 0000007F7E6186D8 System.IO.StdInReader.ReadKey(Boolean ByRef)
0000007FFFFFE940 0000007F7E6179E4 System.IO.StdInReader.ReadLineCore(Boolean)
0000007FFFFFEA80 0000007F7E6175CC System.IO.StdInReader.ReadLine()
0000007FFFFFEAB0 0000007F7E616748 System.IO.SyncTextReader.ReadLine()
0000007FFFFFEAE0 0000007F7E608ACC System.Console.ReadLine()
0000007FFFFFEAF0 0000007F7E4F81E0 dotnethello.Program.Main(System.String[]) [/home/oldzhu/buildroot/output/build/dotnethello-1.0/Program.cs @ 13]
(lldb)
~~~
3. Open a new WSL session,ssh to the started arm64 qemu vm, run another lldb,attach to the above started lldb and start the debugging.
~~~
~$ ssh root@192.168.53.76
# ps aux |grep lldb
  485 root     lldb dotnethello/dotnethello
  488 root     /usr/bin/lldb-server gdbserver --fd=5 --native-regs --setsid
  565 root     grep lldb
# lldb
Using .NET Core runtime to host the managed SOS code
Host runtime path: /root/dotnethello
(lldb) attach 485
This version of LLDB has no plugin for the language "assembler". Inspection of frame variables will be limited.
Process 485 stopped
* thread #1, name = 'lldb', stop reason = signal SIGSTOP
    frame #0: 0x0000007f9bee54c0 libc.so.6`__GI___libc_read at read.c:26:10
   23   ssize_t
   24   __libc_read (int fd, void *buf, size_t nbytes)
   25   {
-> 26     return SYSCALL_CANCEL (read, fd, buf, nbytes);
   27   }
   28   libc_hidden_def (__libc_read)
   29
libc.so.6`__GI___libc_read:
->  0x7f9bee54c0 <+112>: svc    #0
    0x7f9bee54c4 <+116>: mov    x19, x0
    0x7f9bee54c8 <+120>: cmn    x0, #0x1, lsl #12         ; =0x1000
    0x7f9bee54cc <+124>: b.hi   0x7f9bee5504              ; <+180> [inlined] __libc_read at read.c:26:10
  thread #2, name = 'dbg.evt-handler', stop reason = signal SIGSTOP
    frame #0: 0x0000007fa0e1b580 libpthread.so.0`__pthread_cond_wait at futex-internal.h:183:13
   180  {
   181    int oldtype;
   182    oldtype = __pthread_enable_asynccancel ();
-> 183    int err = lll_futex_timed_wait (futex_word, expected, NULL, private);
   184    __pthread_disable_asynccancel (oldtype);
   185    switch (err)
   186      {
libpthread.so.0`__pthread_cond_wait:
->  0x7fa0e1b580 <+352>: svc    #0
    0x7fa0e1b584 <+356>: mov    x1, x0
    0x7fa0e1b588 <+360>: cmn    x0, #0x1, lsl #12         ; =0x1000
    0x7fa0e1b58c <+364>: b.hi   0x7fa0e1b674              ; <+596> [inlined] futex_wait_cancelable at futex-internal.h:184:3
  thread #3, name = 'wait4(pid=488)>', stop reason = signal SIGSTOP
    frame #0: 0x0000007f9bec5d7c libc.so.6`__GI___wait4(pid=<unavailable>, stat_loc=0x0000007f9b50067c, options=1073741824, usage=0x0000000000000000) at wait4.c:30:10
   27   {
   28   #ifdef __NR_wait4
   29   # if __KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64
-> 30     return SYSCALL_CANCEL (wait4, pid, stat_loc, options, usage);
   31   # else
   32     pid_t ret;
   33     struct __rusage32 usage32;
libc.so.6`__GI___wait4:
->  0x7f9bec5d7c <+124>: svc    #0
    0x7f9bec5d80 <+128>: cmn    x0, #0x1, lsl #12         ; =0x1000
    0x7f9bec5d84 <+132>: b.hi   0x7f9bec5dc0              ; <+192> at wait4.c:30:10
    0x7f9bec5d88 <+136>: mov    w19, w0
  thread #4, name = 'b-remote.async>', stop reason = signal SIGSTOP
    frame #0: 0x0000007fa0e1b580 libpthread.so.0`__pthread_cond_wait at futex-internal.h:183:13
   180  {
   181    int oldtype;
   182    oldtype = __pthread_enable_asynccancel ();
-> 183    int err = lll_futex_timed_wait (futex_word, expected, NULL, private);
   184    __pthread_disable_asynccancel (oldtype);
   185    switch (err)
   186      {
libpthread.so.0`__pthread_cond_wait:
->  0x7fa0e1b580 <+352>: svc    #0
    0x7fa0e1b584 <+356>: mov    x1, x0
    0x7fa0e1b588 <+360>: cmn    x0, #0x1, lsl #12         ; =0x1000
    0x7fa0e1b58c <+364>: b.hi   0x7fa0e1b674              ; <+596> [inlined] futex_wait_cancelable at futex-internal.h:184:3
  thread #5, name = 'intern-state', stop reason = signal SIGSTOP
    frame #0: 0x0000007fa0e1b580 libpthread.so.0`__pthread_cond_wait at futex-internal.h:183:13
   180  {
   181    int oldtype;
   182    oldtype = __pthread_enable_asynccancel ();
-> 183    int err = lll_futex_timed_wait (futex_word, expected, NULL, private);
   184    __pthread_disable_asynccancel (oldtype);
   185    switch (err)
   186      {
libpthread.so.0`__pthread_cond_wait:
->  0x7fa0e1b580 <+352>: svc    #0
    0x7fa0e1b584 <+356>: mov    x1, x0
    0x7fa0e1b588 <+360>: cmn    x0, #0x1, lsl #12         ; =0x1000
    0x7fa0e1b58c <+364>: b.hi   0x7fa0e1b674              ; <+596> [inlined] futex_wait_cancelable at futex-internal.h:184:3
  thread #6, name = '.process.stdio>', stop reason = signal SIGSTOP
    frame #0: 0x0000007f9beebc20 libc.so.6`__GI___select(nfds=<unavailable>, readfds=0x0000007f9a3e6ea0, writefds=0x0000000000000000, exceptfds=0x0000000000000000, timeout=0x0000007f9a3e6e80) at select.c:53:12
   50         tsp = &ts;
   51       }
   52
-> 53     result = SYSCALL_CANCEL (pselect6, nfds, readfds, writefds, exceptfds, tsp,
   54                              NULL);
   55
   56     if (timeout)
libc.so.6`__GI___select:
->  0x7f9beebc20 <+192>: svc    #0
    0x7f9beebc24 <+196>: cmn    x0, #0x1, lsl #12         ; =0x1000
    0x7f9beebc28 <+200>: b.hi   0x7f9beebc54              ; <+244> at select.c:53:12
    0x7f9beebc2c <+204>: mov    w20, w0
  thread #7, name = 'lldb-ust', stop reason = signal SIGSTOP
    frame #0: 0x0000007f9beeece4 libc.so.6`syscall at syscall.S:38
   35           mov     x4, x5
   36           mov     x5, x6
   37           mov     x6, x7
-> 38           svc     0x0
   39           cmn     x0, #4095
   40           b.cs    1f
   41           RET
libc.so.6`syscall:
->  0x7f9beeece4 <+36>: svc    #0
    0x7f9beeece8 <+40>: cmn    x0, #0xfff                ; =0xfff
    0x7f9beeecec <+44>: b.hs   0x7f9beeecf4              ; <+52>
    0x7f9beeecf0 <+48>: ret
  thread #8, name = 'lldb-ust', stop reason = signal SIGSTOP
    frame #0: 0x0000007f9beeece4 libc.so.6`syscall at syscall.S:38
   35           mov     x4, x5
   36           mov     x5, x6
   37           mov     x6, x7
-> 38           svc     0x0
   39           cmn     x0, #4095
   40           b.cs    1f
   41           RET
libc.so.6`syscall:
->  0x7f9beeece4 <+36>: svc    #0
    0x7f9beeece8 <+40>: cmn    x0, #0xfff                ; =0xfff
    0x7f9beeecec <+44>: b.hs   0x7f9beeecf4              ; <+52>
    0x7f9beeecf0 <+48>: ret
  thread #9, name = 'lldb', stop reason = signal SIGSTOP
    frame #0: 0x0000007f9bee9604 libc.so.6`__GI___poll(fds=0x0000007f6094b6b0, nfds=1, timeout=<unavailable>) at poll.c:41:10
   38         timeout_ts_p = &timeout_ts;
   39       }
   40
-> 41     return SYSCALL_CANCEL (ppoll, fds, nfds, timeout_ts_p, NULL, 0);
   42   #endif
   43   }
   44   libc_hidden_def (__poll)
libc.so.6`__GI___poll:
->  0x7f9bee9604 <+180>: svc    #0
    0x7f9bee9608 <+184>: cmn    x0, #0x1, lsl #12         ; =0x1000
    0x7f9bee960c <+188>: b.hi   0x7f9bee9644              ; <+244> at poll.c:41:10
    0x7f9bee9610 <+192>: mov    w19, w0
  thread #10, name = 'lldb', stop reason = signal SIGSTOP
    frame #0: 0x0000007f9bee9604 libc.so.6`__GI___poll(fds=0x0000007f8033c900, nfds=1, timeout=-1) at poll.c:41:10
   38         timeout_ts_p = &timeout_ts;
   39       }
   40
-> 41     return SYSCALL_CANCEL (ppoll, fds, nfds, timeout_ts_p, NULL, 0);
   42   #endif
   43   }
   44   libc_hidden_def (__poll)
libc.so.6`__GI___poll:
->  0x7f9bee9604 <+180>: svc    #0
    0x7f9bee9608 <+184>: cmn    x0, #0x1, lsl #12         ; =0x1000
    0x7f9bee960c <+188>: b.hi   0x7f9bee9644              ; <+244> at poll.c:41:10
    0x7f9bee9610 <+192>: mov    w19, w0
  thread #11, name = 'lldb', stop reason = signal SIGSTOP
    frame #0: 0x0000007fa0e1fbe4 libpthread.so.0`__libc_open64(file="/tmp/clr-debug-pipe-485-371848-in", oflag=0) at open64.c:48:10
   45         va_end (arg);
   46       }
   47
-> 48     return SYSCALL_CANCEL (openat, AT_FDCWD, file, oflag | EXTRA_OPEN_FLAGS,
   49                            mode);
   50   }
   51
libpthread.so.0`__libc_open64:
->  0x7fa0e1fbe4 <+180>: svc    #0
    0x7fa0e1fbe8 <+184>: cmn    x0, #0x1, lsl #12         ; =0x1000
    0x7fa0e1fbec <+188>: b.hi   0x7fa0e1fc24              ; <+244> at open64.c:48:10
    0x7fa0e1fbf0 <+192>: mov    w19, w0
  thread #12, name = 'lldb', stop reason = signal SIGSTOP
    frame #0: 0x0000007fa0e1b580 libpthread.so.0`__pthread_cond_wait at futex-internal.h:183:13
   180  {
   181    int oldtype;
   182    oldtype = __pthread_enable_asynccancel ();
-> 183    int err = lll_futex_timed_wait (futex_word, expected, NULL, private);
   184    __pthread_disable_asynccancel (oldtype);
   185    switch (err)
   186      {
libpthread.so.0`__pthread_cond_wait:
->  0x7fa0e1b580 <+352>: svc    #0
    0x7fa0e1b584 <+356>: mov    x1, x0
    0x7fa0e1b588 <+360>: cmn    x0, #0x1, lsl #12         ; =0x1000
    0x7fa0e1b58c <+364>: b.hi   0x7fa0e1b674              ; <+596> [inlined] futex_wait_cancelable at futex-internal.h:184:3
  thread #13, name = '.NET Finalizer', stop reason = signal SIGSTOP
    frame #0: 0x0000007fa0e1b924 libpthread.so.0`__pthread_cond_timedwait at futex-internal.h:320:13
   317      return ETIMEDOUT;
   318    int oldtype;
   319    oldtype = __pthread_enable_asynccancel ();
-> 320    int err = lll_futex_clock_wait_bitset (futex_word, expected,
   321                                          clockid, abstime,
   322                                          private);
   323    __pthread_disable_asynccancel (oldtype);
libpthread.so.0`__pthread_cond_timedwait:
->  0x7fa0e1b924 <+580>: svc    #0
    0x7fa0e1b928 <+584>: mov    x1, x0
    0x7fa0e1b92c <+588>: cmn    x0, #0x1, lsl #12         ; =0x1000
    0x7fa0e1b930 <+592>: b.hi   0x7fa0e1b9e4              ; <+772> [inlined] futex_abstimed_wait_cancelable at futex-internal.h:323:3
Executable module set to "/usr/bin/lldb".
Architecture set to: aarch64-unknown-linux-gnu.
(lldb) image list
[  0] 06431E41 0x000000558bac0000 /usr/bin/lldb
[  1] D3C411EE-0486-5C3A-550A-BD0319D00B09-CA2C53A0 0x0000007fa0e6f000 [vdso] (0x0000007fa0e6f000)
[  2] 6F18CD34 0x0000007fa0e0e000 /lib64/libpthread.so.0
[  3] 8C907678 0x0000007fa0408000 /usr/lib64/liblldb.so.13git
[  4] 6D32A039 0x0000007f9e0fb000 /usr/lib64/libclang-cpp.so.13git
[  5] F0F293BB 0x0000007f9c1ed000 /usr/lib64/libLLVM-13git.so
[  6] BCF14096 0x0000007f9c05e000 /usr/lib64/libstdc++.so.6
[  7] 7B81C1FD 0x0000007f9bfb5000 /lib64/libm.so.6
[  8] 891EC04E 0x0000007f9bf93000 /lib64/libgcc_s.so.1
[  9] 399C1384 0x0000007f9be25000 /lib64/libc.so.6
[ 10] EE40D8EF 0x0000007fa0e3e000 /lib/ld-linux-aarch64.so.1
[ 11] D2381993 0x0000007f9bdcf000 /usr/lib64/libncurses.so.6
[ 12] 972CA7DA 0x0000007f9bdb0000 /usr/lib64/libform.so.6
[ 13] 47F69E44 0x0000007f9bd9c000 /usr/lib64/libpanel.so.6
[ 14] FFE0795F 0x0000007f9bd88000 /lib64/libdl.so.2
[ 15] 6B85AD6B 0x0000007f9bd70000 /lib64/librt.so.1
[ 16] E85BF4D2-69C6-FE3E-ADC4-648E6BA5FFBD-BF4C0336 0x0000007f9bd37000 /root/.dotnet/sos/libsosplugin.so
[ 17] 9972B066 0x0000007f9b502000 /lib64/libnss_files.so.2
[ 18] 9F494D7A-A7C3-89D2-14FE-4BB106ABB594-0FDDF18C 0x0000007f704a2000 /root/.dotnet/sos/libsos.so
[ 19] 4029DDE4-835B-6BA8-07A9-F447499D289F-B94928AD 0x0000007f6094d000 /root/dotnethello/libcoreclr.so
      /root/dotnethello/libcoreclr.so.dbg
[ 20] A577BD51-9216-4D33-4152-30196F1DFD2A-1C950AA0 0x0000007f703de000 /root/dotnethello/libcoreclrtraceptprovider.so
      /root/dotnethello/libcoreclrtraceptprovider.so.dbg
[ 21] 395A5DE0 0x0000007f7035c000 /usr/lib64/liblttng-ust.so.0
[ 22] F6AC9BB3 0x0000007f70332000 /usr/lib64/liblttng-ust-tracepoint.so.0
[ 23] 5270F3D2 0x0000007f7ae55000 /usr/lib64/liburcu-bp.so.6
[ 24] 2BF38621 0x0000007f70318000 /usr/lib64/liburcu-cds.so.6
[ 25] D0C899B0 0x0000007f70303000 /usr/lib64/liburcu-common.so.6
[ 26] E0D49E0B-7CF7-053D-27C7-5E8F3BA848FC-4CD1625C 0x0000007f7005a000 /root/dotnethello/libclrjit.so
      /root/dotnethello/libclrjit.so.dbg
[ 27] 69D8375D-1CFC-0D4E-0A6C-7B66E3B93729-0BFDF64A 0x0000007f60016000 /root/dotnethello/libSystem.Native.so
      /root/dotnethello/libSystem.Native.so.dbg
[ 28] 717B9EA5 0x0000007f59195000 /usr/lib64/libicuuc.so.68
[ 29] 49DB9C5B 0x0000007f524b0000 /usr/lib64/libicudata.so.68
[ 30] CCFC5673 0x0000007f5917b000 /lib64/libatomic.so.1
[ 31] 0C6295E5 0x0000007f58eb4000 /usr/lib64/libicui18n.so.68
[ 32] 50CBD5D8-EB68-5D39-48F6-9F383B8AE53A-7A03D588 0x0000007f58b64000 /root/dotnethello/libmscordaccore.so
      /root/dotnethello/libmscordaccore.so.dbg
(lldb)
~~~
<img src="arm64lldbsos_demo_120.gif" width="1500"/>