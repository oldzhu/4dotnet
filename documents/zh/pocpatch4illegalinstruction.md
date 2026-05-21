# 非法指令 POC 补丁

> 本文档是 pocpatch4illegalinstruction.md 的中文翻译版。
> This document is the Chinese translation of pocpatch4illegalinstruction.md.

1. 使用以下命令应用 POC 补丁：
~~~
        rpath=$(find $HOME/buildroot/output/build -maxdepth 1 -name dotnetruntime-\* -type d -print -quit);patch -N -d $rpath/src/coreclr/jit -p0 -u -b emitarm.cpp -i $HOME/4dotnet/package/dotnetcore/dotnetruntime/emitarm.cpp.mypatch
~~~
2. 重建 dotnet core 运行时：
~~~
        export PATH=`echo $PATH|tr -d ' '`
        make dotnetruntime-rebuild
~~~
3. 删除 dotnethello 演示程序的本地缓存。
~~~
        rm -r $HOME/buildroot/output/build/dotnethello-1.0/localcache
~~~
4. 重建 dotnethello 和新的系统镜像。
~~~
        make dotnethello-rebuild all
~~~

或者运行包含所有上述命令的脚本：
~~~
        $HOME/4dotnet/scripts/patcharmvm.sh
~~~
