it contains the steps to build arm/arm64 vm for .net core debugging.
1. [Setup wsl2 + ubuntu distribution on winddows 10](https://docs.microsoft.com/en-us/windows/wsl/install-win10) 
2. Install the following prerequired softwares on wsl2 + ubuntu 
 
    * make
    * unzip
    * gcc
    * g++
    * libncurses-dev
    * liblttng-ust-dev 
 
3. Clone buildroot and 4dotnet to your home folder. 
~~~
    git clone https://git.buildroot.net/buildroot 
    git clone https://github.com/oldzhu/4dotnet.git
~~~ 
4. Copy the customized buildroot config from 4dotnet to the buildroot folder.  

**for arm:**
~~~
        
    cp ~/4dotnet/savedconfigs/arm/.qemu_arm_vexpress_config ~/buildroot/.config
~~~  
**for arm64:**
~~~
    cp ~/4dotnet/savedconfigs/arm64/.qemu_aarch64_virt_config ~/buildroot/.config
~~~
5. Run the command make menuconfig to set Toolchain options.
~~
    make BR2_EXTERNAL=~/4dotnet menuconfig
~~

check the following setting and select the latest version avaiable if it is not

~~
    Toolchain -> Custom kernel headers series  
    Toolchain -> Binutils Version  
    Toolchain -> GCC compiler Version 
    Toolchain -> GDB debugger version 
~~

5. Run the below make command to begin 1st pass build. It could take serveral housrs or even days depends on your system power.
~~~
    export PATH=`echo $PATH|tr -d ' '`
    make
~~~
6. Copy the customized linux config from 4dotnet to the buildroot linux build folder.  

**for arm:**
~~~
    find ~/buildroot/output/build -iname "linux-[4-9]*" -type d -exec cp ~/4dotnet/savedconfigs/arm/.linux_config '{}'/.config \; -quit
~~~ 
**for arm64:**
~~~
    find ~/buildroot/output/build -iname "linux-[4-9]*" -type d -exec cp ~/4dotnet/savedconfigs/arm64/.linux_config '{}'/.config \; -quit
~~~
7. Run the below command to show the linux build configs, press exit and save the configs. 
~~~
make linux-menuconfig
~~~ 
8. Run the below make command to begin 2nd pass build to rebuild the linux kernel with the above copied config and normally it should quick.
~~~
    make
~~~
9. Done and now you can go to [Using the arm VM to debug](debug-arm.md) or [Using the arm64 VM to debug](debug-arm64.md) to enjoy a .netcore app debugging.
