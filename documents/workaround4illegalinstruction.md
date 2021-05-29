1. Modify the line in ~/4dotnet/dotnetcore/dotnetruntime/build_dotnetruntime.sh as the below   
from
~~~
        $4/build.sh \
        -subset clr+libs+host+packs \
        -arch $3 \
        -cross \
        -c release \
        /p:EnableSourceLink=false
~~~
to
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
2. Rebuild dotnet core runtime by the below command
~~~
        export PATH=`echo $PATH|tr -d ' '`
        make dotnetruntime-rebuild
~~~ 
3. Remove the local cache of the dotnethello demo program.
~~~
        rm -r $HOME/buildroot/output/build/dotnethello-1.0/localcache
~~~
4. Run the below make command to rebuild the dotnethello and the new system image. 
~~~
        make dotnethello-rebuild all
~~~