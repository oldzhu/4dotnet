# 非法指令变通方案

> 本文档是 workaround4illegalinstruction.md 的中文翻译版。
> This document is the Chinese translation of workaround4illegalinstruction.md.

1. 修改 `~/4dotnet/package/dotnetcore/dotnetruntime/build_dotnetruntime.sh` 中的行：

从：
~~~
        $4/build.sh \
        -subset clr+libs+host+packs \
        -arch $3 \
        -cross \
        -c release \
        /p:EnableSourceLink=false
~~~
改为：
~~~
        $4/build.sh \
        -subset clr+libs+host+packs \
        -arch $3 \
        -cross \
        -c release \
        -v d \
        /p:EnableSourceLink=false \
        /p:PublishReadyToRun=false
~~~
2. 使用以下命令重建 dotnet core 运行时：
~~~
        export PATH=`echo $PATH|tr -d ' '`
        make dotnetruntime-rebuild
~~~
3. 删除 dotnethello 演示程序的本地缓存。
~~~
        rm -r $HOME/buildroot/output/build/dotnethello-1.0/localcache
~~~
4. 运行以下 make 命令重建 dotnethello 和新的系统镜像。
~~~
        make dotnethello-rebuild all
~~~

或者直接运行变通脚本：
~~~
        $HOME/4dotnet/scripts/workaroundarmvm.sh
~~~
