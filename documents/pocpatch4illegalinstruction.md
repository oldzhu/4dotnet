1. Apply the POC patch by the below command
~~~
        rpath=$(find $HOME/buildroot/output/build -maxdepth 1  -name dotnetruntime-\* -type d -print -quit);patch -N -d $rpath/src/coreclr/jit -p0 -u -b emitarm.cpp -i $HOME/4dotnet/package/dotnetcore/dotnetruntime/emitarm.cpp.mypatch
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
  
or simply run the script patcharmvm.sh which contains all commands above
~~~
        $HOME/4dotnet/scripts/patcharmvm.sh
~~~