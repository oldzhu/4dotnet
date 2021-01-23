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
4. Copy the customized buildroot config from 4dotnet to the buildroot.  
~~~
        cp ~/4dotnet/
~~~
yes n | make BR2_EXTERNAL=~/4dotnet