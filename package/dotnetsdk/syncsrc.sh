#!/bin/sh
giturl="https://github.com/dotnet/runtime.git"
commit=$(head -n 1 $(find $1/shared/Microsoft.NETCore.App -iname .version))
echo "commit:"$commit
mkdir $1/src
cd $1/src
git init
git fetch $giturl $commit
git checkout FETCH_HEAD
