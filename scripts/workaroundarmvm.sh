#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
runtimebldscript=$HOME/4dotnet/package/dotnetcore/dotnetruntime/build_dotnetruntime.sh
sed -i 's/EnableSourceLink=false/EnableSourceLink=false \\/' $runtimebldscript
sed -i '$a/p:PublishReadyToRun=false' $runtimebldscript

pushd $HOME/buildroot
export PATH=`echo $PATH|tr -d ' '`
make dotnetruntime-rebuild
rm -r $HOME/buildroot/output/build/dotnethello-1.0/localcache
make dotnethello-rebuild all
popd

sed -i 's/EnableSourceLink=false \\/EnableSourceLink=false/' $runtimebldscript
sed -i '$d' $runtimebldscript
