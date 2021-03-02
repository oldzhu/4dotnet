#export DOTNET_ROOT=$HOME/dotnet
#export PATH=$PATH:$HOME/dotnet
#if [ ! -d "$HOME/.dotnet/tools" ]
#if [ ! -d "$HOME/.dotnet" ]
#then
#	dotnet tool install -g dotnet-sos
#	export PATH=$PATH:$HOME/.dotnet/tools
#	dotnet-sos install
#	echo 'settings set target.source-map /__w/1/s/src/ /root/dotnet/src' >>  /root/.lldbinit
#else
#	export PATH=$PATH:$HOME/.dotnet/tools
#fi
#if ! mount | grep buildroot > /dev/null 
if [ ! -d "/root/buildroot/output" ]
then
	mkdir -p /root/buildroot
	mount -t 9p -o trans=virtio,version=9p2000.L hostshare /root/buildroot
fi
