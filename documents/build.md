it contains the steps to build arm/arm64 vm for .net core debugging.
1. [Setup wsl2 + ubuntu distribution on winddows 10](https://docs.microsoft.com/en-us/windows/wsl/install-win10) 
2. Install the following prerequired softwares on wsl2 + ubuntu 
 
    * make
    * unzip
    * gcc
    * g++
    * libncurses-dev
    * liblttng-ust-dev 
 ~~~
 sudo apt-get update
 sudo apt intstall make
 sudo apt install unzip
 sudo apt install gcc
 sudo apt install g++
 sudo apt install libncurses-dev
 sudo apt install liblttng-ust-dev
 ~~~
3. Clone buildroot and 4dotnet to your home folder. 
~~~
    git clone https://github.com/oldzhu/buildroot.git 
    git clone https://github.com/oldzhu/4dotnet.git
~~~ 
4. Run the below commands to update the default config to build vm.  

**for arm:**
~~~
    cd buildroot
    make distclean
    make BR2_EXTERNAL=~/4dotnet defconfig BR2_DEFCONFIG=~/4dotnet/savedconfigs/arm/br2.defconfig
~~~  
**for arm64:**
~~~
    cd buildroot
    make distclean
    make BR2_EXTERNAL=~/4dotnet defconfig BR2_DEFCONFIG=~/4dotnet/savedconfigs/arm64/br2.defconfig
~~~

5. Run the below make command to begin the build. It could take serveral housrs or even days depends on your system power.
~~~
    export PATH=`echo $PATH|tr -d ' '`
    make
~~~
6. Done and now you can go to [Using the arm VM to debug](documents/debug-arm-netcoreapp.md) or [Using the arm64 VM to debug](documents/debug-arm64-netcoreapp.md) to enjoy a .netcore app debugging.
