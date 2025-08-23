#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR

dotnetruntimepath=$(find $1 -maxdepth 1  -name dotnetruntime-\* -type d -print -quit)
clrmdpath=$(find $1 -maxdepth 1  -name clrmd-\* -type d -print -quit)
symstorepath=$(find $1 -maxdepth 1  -name symstore-\* -type d -print -quit)

# Check if the directory '$4/artifacts/bin/Linux.*' exists
if [ -d "$4/artifacts/bin/Linux.*" ]; then
    sourcepath=($4/artifacts/bin/Linux.*)
else
    sourcepath=($4/artifacts/bin/linux.*)
fi

mkdir -p $7/root/.dotnet/sos
cp -v $sourcepath/* $7/root/.dotnet/sos

# Function to copy files from dynamically detected build paths
copy_dynamic_files() {
    local base_path=$1
    local dest=$2
    local pattern=$3
    
    # Try to find release/debug directories (case-insensitive)
    for build_dir in "$base_path"/*; do
        if [ ! -d "$build_dir" ]; then
            continue
        fi
        
        build_name=$(basename "$build_dir")
        build_lower=${build_name,,}  # Convert to lowercase
        
        # Check if it's release or debug directory
        if [[ "$build_lower" == "release" || "$build_lower" == "debug" ]]; then
            # Find netX.X directories
            for net_dir in "$build_dir"/net*; do
                if [ ! -d "$net_dir" ]; then
                    continue
                fi
                
                net_name=$(basename "$net_dir")
                # Check if directory matches net<digit> pattern
                if [[ "$net_name" =~ ^net[0-9] ]]; then
                    echo "Copying $pattern from $net_dir to $dest"
                    cp -v "$net_dir"/$pattern "$dest"
                fi
            done
        fi
    done
}

# Copy files using dynamic detection
copy_dynamic_files "$clrmdpath/artifacts/bin/Microsoft.Diagnostics.Runtime" "$7/root/.dotnet/sos" "*.dll"
copy_dynamic_files "$symstorepath/artifacts/bin/SymClient" "$7/root/.dotnet/sos" "Microsoft.FileFormats.*"
copy_dynamic_files "$symstorepath/artifacts/bin/SymClient" "$7/root/.dotnet/sos" "Microsoft.SymbolStore.*"

# Determine runtime architecture
case $3 in
    ARM64) runtime_arch="linux-arm64" ;;
    ARM)   runtime_arch="linux-arm" ;;
    *)     runtime_arch="linux-${3,,}" ;;
esac

# Find and copy System.Collections.Immutable and System.Reflection.Metadata DLLs
dlls_found=0
for build_dir in "$dotnetruntimepath/artifacts/bin/microsoft.netcore.app.runtime.$runtime_arch"/*; do
    if [ ! -d "$build_dir" ]; then
        continue
    fi
    
    build_name=$(basename "$build_dir")
    build_lower=${build_name,,}  # Convert to lowercase
    
    # Check if it's release or debug directory
    if [[ "$build_lower" == "release" || "$build_lower" == "debug" ]]; then
        # Look for runtime lib path
        lib_path="$build_dir/runtimes/$runtime_arch/lib"
        if [ -d "$lib_path" ]; then
            # Find netX.X directories
            for net_dir in "$lib_path"/net*; do
                if [ ! -d "$net_dir" ]; then
                    continue
                fi
                
                net_name=$(basename "$net_dir")
                # Check if directory matches net<digit> pattern
                if [[ "$net_name" =~ ^net[0-9] ]]; then
                    echo "Copying DLLs from $net_dir to $7/root/.dotnet/sos"
                    cp -v "$net_dir"/System.Collections.Immutable.dll "$7/root/.dotnet/sos"
                    cp -v "$net_dir"/System.Reflection.Metadata.dll "$7/root/.dotnet/sos"
                    dlls_found=1
                fi
            done
        fi
    fi
done

if [ $dlls_found -eq 0 ]; then
    echo "Warning: System.Collections.Immutable and System.Reflection.Metadata DLLs not found in expected location for $runtime_arch"
fi
