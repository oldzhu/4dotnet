#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR

# Script based on documentation at https://github.com/dotnet/runtime/blob/master/docs/workflow/using-dotnet-cli.md
# This script needs updates if the documentation changes

dotnetruntimepath=$(find $1 -maxdepth 1  -name dotnetruntime-\* -type d -print -quit)
packpath=$dotnetruntimepath/artifacts/packages
subdirs=($packpath/*)
localpath=${subdirs[0]}/Shipping
runtimepackname=($localpath/Microsoft.NETCore.App.Runtime.*.nupkg)
ridverpkg=${runtimepackname[0]##*Microsoft.NETCore.App.Runtime.}

if [ -z "$ridverpkg" ]; then
    echo "Error: Could not find local dotnet core runtime package!"
    exit 1
fi

ridver=${ridverpkg%%.nupkg*}
rid=${ridver%%.*}
ver=${ridver#*.}

# ==================== Modified .NET Setup ====================
# Create symbolic link to existing .NET installation
if [ -d "${dotnetruntimepath}/.dotnet" ]; then
    echo "Reusing existing .NET installation at ${dotnetruntimepath}/.dotnet"
    mkdir -p $4
    ln -sfn "${dotnetruntimepath}/.dotnet" "$4/.dotnet"
    
    mkdir -p $4/localcache 
    echo "Added symbolic link to .NET: $4/.dotnet → ${dotnetruntimepath}/.dotnet"
else
    echo "Error: No existing .NET installation found at ${dotnetruntimepath}/.dotnet"
    exit 1
fi
# =============================================================

# Detect SDK version and configure dynamically
if [ -f "$4/.dotnet/dotnet" ]; then
    dotnet_version=$($4/.dotnet/dotnet --version)
    major_version=$(echo $dotnet_version | cut -d '.' -f 1)
    target_framework="net${major_version}.0"
    feed_url="https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet${major_version}/nuget/v3/index.json"
    
    echo "Detected .NET SDK version: $dotnet_version"
    echo "Using target framework: $target_framework"
    echo "Using feed URL: $feed_url"
else
    echo "Error: .NET SDK binary not found"
    exit 1
fi

# Generate NuGet configuration file
cat <<EOF > $4/nuget.config
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <config>
    <add key="globalPackagesFolder" value="$4/localcache" />
  </config>
  <packageSources>
    <clear />
    <!-- Official .NET feed -->
    <add key="dotnet${major_version}" value="$feed_url" />
    <!-- Local build artifacts -->
    <add key="local runtime" value="$localpath" />
  </packageSources>
</configuration>
EOF

# Generate project file with dynamic target framework
cat <<EOF > $4/dotnethello.csproj
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>$target_framework</TargetFramework>
    <RuntimeIdentifier>$rid</RuntimeIdentifier>
  </PropertyGroup>
  <ItemGroup>
    <FrameworkReference Update="Microsoft.NETCore.App" RuntimeFrameworkVersion="$ver" />
  </ItemGroup>
</Project>
EOF
