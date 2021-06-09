# Download the VM

To download arm vm
~~~
wget https://github.com/oldzhu/4dotnet/releases/download/v1.0.0/dotnet_arm_linux_vm_[dd-mm-yyyy].tar.xz.00
wget https://github.com/oldzhu/4dotnet/releases/download/v1.0.0/dotnet_arm_linux_vm_[dd-mm-yyyy].tar.xz.01
cat $HOME/dotnet_arm_linux_vm_[dd-mm-yyyy].tar.xz.0* > $HOME/dotnet_arm_linux_vm_[dd-mm-yyyy].tar.xz
tar -xvf $HOME/dotnet_arm_linux_vm_[dd-mm-yyyy].tar.xz -C $HOME
~~~  

To download arm64 vm
~~~
wget https://github.com/oldzhu/4dotnet/releases/download/v1.0.0/dotnet_arm64_linux_vm_[dd-mm-yyyy].tar.xz.00
wget https://github.com/oldzhu/4dotnet/releases/download/v1.0.0/dotnet_arm64_linux_vm_[dd-mm-yyyy].tar.xz.01
cat $HOME/dotnet_arm64_linux_vm_[dd-mm-yyyy].tar.xz.0* > $HOME/dotnet_arm64_linux_vm_[dd-mm-yyyy].tar.xz
tar -xvf $HOME/dotnet_arm64_linux_vm_[dd-mm-yyyy].tar.xz -C $HOME
~~~  
  
**replace the [dd-mm-yyyy] with the real date time you see in the latest github release.**  