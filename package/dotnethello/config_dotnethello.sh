#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR

# the script based on the document at https://github.com/dotnet/runtime/blob/master/docs/workflow/using-dotnet-cli.md
# it need change too if there is change in the document

dotnetruntimepath=$(find $1 -maxdepth 1  -name dotnetruntime-\* -type d -print -quit)
#packpath=$1/dotnetruntime-origin_main/artifacts/packages
packpath=$dotnetruntimepath/artifacts/packages
subdirs=($packpath/*)
localpath=${subdirs[0]}/Shipping
runtimepackname=($localpath/Microsoft.NETCore.App.Runtime.*.nupkg)
ridverpkg=${runtimepackname[0]##*Microsoft.NETCore.App.Runtime.}
if [ -z "$ridverpkg" ]; then
	echo "could not find local dotnet core runtime package!"
	exit 1
fi 
ridver=${ridverpkg%%.nupkg*}
rid=${ridver%%.*}
ver=${ridver#*.}

global_json_file="${dotnetruntimepath}/global.json"

function ReadGlobalVersion {
  local key=$1
  if command -v jq &> /dev/null; then
     _ReadGlobalVersion="$(jq -r ".[] | select(has(\"$key\")) | .\"$key\"" "$global_json_file")"
  elif [[ "$(cat "$global_json_file")" =~ \"$key\"[[:space:]\:]*\"([^\"]+) ]]; then
     _ReadGlobalVersion=${BASH_REMATCH[1]}
  fi
}

if [ ! -f "$4/.dotnet/dotnet" ]; then
	mkdir -p -v $4/.dotnet
	mkdir -p -v $4/localcache
	# based on document https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script
	# download dotnet install script and install the nightly release dotnet sdk into .dotnet
	pushd $4
	wget https://dot.net/v1/dotnet-install.sh
	chmod +x ./dotnet-install.sh
	#ReadGlobalVersion "dotnet"
	if [[ -z "$_ReadGlobalVersion" ]]; then
	   ./dotnet-install.sh --channel master --install-dir $4/.dotnet
	else
	   ./dotnet-install.sh --version $_ReadGlobalVersion --install-dir $4/.dotnet
	fi
	popd
fi

cat <<EOF > $4/nuget.config
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <config>
    <!-- CHANGE THIS PATH BELOW to any empty folder. NuGet will cache things here, and that's convenient because you can delete it to reset things -->
    <add key="globalPackagesFolder" value="$4/localcache" />
      </config>
        <packageSources>
    <!--To inherit the global NuGet package sources remove the <clear/> line below -->
    <clear />
    <!-- This feed is for any packages you didn't build. See https://github.com/dotnet/installer#installers-and-binaries -->
    <add key="dotnet6" value="https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet6/nuget/v3/index.json" />
    <!-- CHANGE THIS PATH BELOW to your local output path -->
    <add key="local runtime" value="$localpath" />
  </packageSources>
</configuration>
EOF

cat <<EOF > $4/dotnethello.csproj
<Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
                <OutputType>Exe</OutputType>
                <TargetFramework>net6.0</TargetFramework>
                <RuntimeIdentifier>$rid</RuntimeIdentifier>
        </PropertyGroup>
        <ItemGroup>
                <FrameworkReference Update="Microsoft.NETCore.App" RuntimeFrameworkVersion="$ver" />
        </ItemGroup>
</Project>
EOF
