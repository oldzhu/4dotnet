#~/bin/sh
packpath=/home/oldzhu/buildroot/output/build/dotnetruntime-origin_main/artifacts/packages
subdirs=($packpath/*)
localpath=${subdirs[0]}/Shipping
runtimepackname=($localpath/Microsoft.NETCore.App.Runtime.*.nupkg)
ridverpkg=${runtimepackname[0]##*Microsoft.NETCore.App.Runtime.}
ridver=${ridverpkg%%.nupkg*}
rid=${ridver%%.*}
ver=${ridver#*.}
echo $rid
echo $ver
publishpath=(/home/oldzhu/buildroot/output/build/dotnethello-1.0/bin/*/*/*/publish)
echo $publishpath

cat <<EOF > nuget.config
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
      <!--To inherit the global NuGet package sources remove the <clear/> line below -->
    <clear />
    <add key="local runtime" value="$localpath" />
   </packageSources>
</configuration>
EOF

cat <<EOF > dotnethello.csproj
<Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
                <OutputType>Exe</OutputType>
                <TargetFramework>net5.0</TargetFramework>
                <RuntimeIdentifier>$rid</RuntimeIdentifier>
        </PropertyGroup>
        <ItemGroup>
                <FrameworkReference Update="Microsoft.NETCore.App" RuntimeFrameworkVersion="$ver" />
        </ItemGroup>
</Project>
EOF
